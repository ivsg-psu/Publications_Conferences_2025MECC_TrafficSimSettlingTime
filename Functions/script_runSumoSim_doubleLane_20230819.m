% This script does the following things: 
% 1. generate route file xx.rou.xml
% 2. modify sumocfg files: modify the route definition in the sumocfg files
% to be the one generated
% 3. run simulation with different random seeds
% 4. run the simulations 
% 5. convert simulat results from xml to csv

% Author: Wushuang Bai
% Created on: 2022 11 27

% TODO LIST:
% 1. for baseline, do not touch xx.via.xml -- done
% 2. test this script -- done
% 3. add if statements for different simulation scenarios. -- done

% Revision history:
% 20230301: add code to add additional xml file into the sumocfg file for MFD calculation
% 20230313: change trip_time_length to trip_flow_length, add
% trip_sim_length to force the end of simulation
% 20230329: add code to convert edge xml to csv, for plotting purpose
% 20231120: cleaned code. updated comments
% 20231124: added code to fix the first line of aggregated results in xml
% file, because usually the first edge misses some attributes due to
% traffic initialization 

%% user's inputs
% check OS
flag_aggregated = 1;
flag_runPer = 1;
%% Generate route files:
% define files to use
% net file
if strcmp(sim_name,'PortionOfSC')
trip_net_file = ['bl_',sim_name,'_no_tls.net.xml'];

elseif  strcmp(sim_name,'300m_9x9_twoLane_twoDirection_remove1Lane')
trip_net_file = ['bl_',sim_name,'.net.xml'];
end

tripCMD = fcn_generateRandomTripFile(sim_name,trip_net_file,trip_flow_length,flag.period, ...
    'routeFile',[sim_name,'.rou.xml']);
fprintf("Trip file generated! \n");

%% Modify simulation files 
% This is to modify route file definitions in the simulations files to be
% the ones that were generated in the last section
% This works for all the sumocfg file in the directory
fcn_modifyRoute(executionPath,sim_name);

%% Run simulations% 
% The following files are needed:
% 1. simulation file: xx.sumocfg
% 2. route file: xx.trips.xml
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% result_file.bl = ['bl_result_',sim_name,'_',flag.period,'_sec','.xml'];
% result_file.per = ['per_result_',sim_name,'_',flag.period,'_sec','.xml'];
% add_file.bl = 'template_bl.add.xml';
% add_file.per = 'template_per.add.xml';
cfg.bl = ['bl_',sim_name];
cfg.per =['per_',sim_name];
tstart = tic;
for ii = 1:length(aggreInterval)
    add_file = ['add',aggreInterval{ii},'.add.xml'];
    for jj = 1:numOfSeed % random seed number
        tic;
        aggrePrefix.bl  =  ['/',resultsFolder,'/bl_seed_',num2str(jj),'_aggreInterval_',num2str(aggreInterval{ii})];
        aggrePrefix.per =  ['/',resultsFolder,'/per_seed_',num2str(jj),'_aggreInterval_',num2str(aggreInterval{ii})];       

        if 1 == flag_aggregated
            fcn_runSumoSim(cfg.bl,trip_sim_length,add_file,  'seed', jj, 'outputPrefix',aggrePrefix.bl);
            if 1 == flag_runPer
                fcn_runSumoSim(cfg.per,trip_sim_length,add_file,  'seed', jj, 'outputPrefix',aggrePrefix.per);
            end
        end

        toc;
        fprintf("Random seed %d is done! \n",jj);
    end
end
fprintf("SUMO simulation is done! \n");
fprintf("Total time consumption is %d sec! \n", toc(tstart));

%% convert edge-based results: xml -> csv

fileRegExpression = ['*_',aggreInterval{1},'aggregated.xml'];
% first the first line of aggregated results in xml
warning('Please fix the first line of all xml files using python scripts before proceeding!');
if flag.parsexml == 1
fcn_xml2csv_multipleFiles(aggreResultsPath,fileRegExpression);
fprintf("Edge based results has been converted to csv format! \n");
end





