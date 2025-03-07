% The goal of this script is to generate baseline simulations.
% The results can be used for analysis of :
% 1. Determining settling time
% 2. Compare with perturbed for ROI analysis

%% user inputs

clear;clc;close all;
folder = fileparts(mfilename("fullpath"));
figPath = fullfile(folder,'Fig');
%%%%%%%%%%%%%%%%%%%% USER INPUTS%%%%%%%%%%%%%%%%%%%%%%

%sim_name        = '300m_9x9_twoLane_twoDirection_remove1Lane';
sim_name       = 'PortionOfSC';
trip_sim_length = '10800';
%aggreInterval  = {'60','120','300','600','1200'};
aggreInterval   = {'60'};
numOfSeed       = 100;
flag_runPer     = 0;   % do you want to run perturbed simulations?
flag_FCD        = 1;   % do you want to generate FCD outputs?
flag_aggregated = 1;
fcdPeriod       = 10;  % what period do you want to generate FCD?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
executionPath   = fullfile(folder,'SUMO',sim_name,'3600vehPerHr');
cd(executionPath);
resultsFolder   = ['aggregatedResults_',datestr(datetime('today'),'yyyy_mm_dd')];
mkdir(resultsFolder);


%% data execution
cfg.bl = ['bl_',sim_name];
cfg.per =['per_',sim_name];
tstart = tic;
for ii = 1:length(aggreInterval)
    add_file = ['add',aggreInterval{ii},'.add.xml'];
    for jj = 1:numOfSeed % random seed number
        tic;
        aggrePrefix.bl  =  ['/',resultsFolder,'/bl_seed_',num2str(jj),'_aggreInterval_',num2str(aggreInterval{ii})];
        aggrePrefix.per =  ['/',resultsFolder,'/per_seed_',num2str(jj),'_aggreInterval_',num2str(aggreInterval{ii})];
        fcdOutput.bl    =  ['./',resultsFolder,'/bl_seed_',num2str(jj),'_outputPeriod_',num2str(fcdPeriod),'.xml'];
        fcdOutput.per   =  ['./',resultsFolder,'/per_seed_',num2str(jj),'_outputPeriod_',num2str(fcdPeriod),'.xml'];

        if 1 == flag_aggregated
            fcn_runSumoSim(cfg.bl,trip_sim_length,add_file,  'seed', jj, 'outputPrefix',aggrePrefix.bl);
            if 1 == flag_runPer
                fcn_runSumoSim(cfg.per,trip_sim_length,add_file,  'seed', jj, 'outputPrefix',aggrePrefix.per);
            end
        end
        if 1 == flag_FCD
            fcn_runSumoSim(cfg.bl,trip_sim_length,add_file,  'seed', jj, 'fcdOutput',fcdOutput.bl, ...
                'fcdPeriod',fcdPeriod);
        end
        toc;
        fprintf("Random seed %d is done! \n",jj);
    end
end
fprintf("SUMO simulation is done! \n");
fprintf("Total time consumption is %d sec! \n", toc(tstart));