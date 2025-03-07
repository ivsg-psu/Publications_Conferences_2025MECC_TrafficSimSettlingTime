% This script does the following things: 
% 1. generate road trip file xx.rou.xml and the relevant source filfe
% xx.src.xml, destination file xx.dst.xml and mid way points file
% xx.via.xml
% 2. remove the given edges from the source file, destination file.
% For files of perturbed simulation, also remove edges from the mid way
% points file
% 3. generate simulation configuration file xx.sumocfg
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
% 20230414: 


%% user's inputs

% check OS

sim_dir = executionPath;
python = 'python ';

%% Generate road trip file:
% define files to use
% net file
trip_net_file = ['bl_',sim_name,'.net.xml'];

tripFileName = fcn_generateRandomTripFile(sim_name,trip_net_file,trip_flow_length,flag.period);

fprintf("Trip file generated! \n");

%% Run simulations% 
% The following files are needed:
% 1. simulation file: xx.sumocfg
% 2. route file: xx.trips.xml
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
result_file.bl = ['bl_result_',sim_name,'_',flag.period,'_sec','.xml'];
result_file.per = ['per_result_',sim_name,'_',flag.period,'_sec','.xml'];
add_file.bl = 'template_bl.add.xml';
add_file.per = 'template_per.add.xml';
cfg.bl = ['bl_',sim_name];
cfg.per =['per_',sim_name];

% run baseline simulation
fcn_runSumoSim(cfg.bl,trip_sim_length,add_file.bl);
% run perturbed simulation
fcn_runSumoSim(cfg.per,trip_sim_length,add_file.per);

fprintf("SUMO simulation is done! \n");

%% convert simulation results: xml -> csv 
% fcn_xml2csv(result_file.bl);
% fcn_xml2csv(result_file.per);
% fprintf("Simulation results has been converted to csv format! \n");


%% convert edge-based results: xml -> csv
aggregatedResult.bl = 'bl_aggregated.xml';
aggregatedResult.per = 'per_aggregated.xml';
if strcmp(sim_name,'PortionOfSC')
cmd.fixBlAggregated = ['python ',function_dir,'pyscript_fixAggregated_SC.py ',aggregatedResult.bl];
cmd.fixPerAggregated = ['python ',function_dir,'pyscript_fixAggregated_SC.py ',aggregatedResult.per];
elseif strcmp(sim_name,'300m_9x9_twoLane_twoDirection_remove1Lane')
cmd.fixBlAggregated = ['python ',function_dir,'pyscript_fixAggregated_9X9.py ',aggregatedResult.bl];
cmd.fixPerAggregated = ['python ',function_dir,'pyscript_fixAggregated_9X9.py ',aggregatedResult.per];
end

fcn_executeCommand(cmd.fixBlAggregated);
fcn_executeCommand(cmd.fixPerAggregated);

fcn_xml2csv(aggregatedResult.bl);
fcn_xml2csv(aggregatedResult.per);
fprintf("Edge based results has been converted to csv format! \n");






