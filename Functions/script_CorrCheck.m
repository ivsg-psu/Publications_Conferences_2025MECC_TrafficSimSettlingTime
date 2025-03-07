% This script does the following.

% 1. Check the correlation coefficients between adjacent aggregated results
% along time, in the same iteration
% 2. Check the variance between adjacent aggregated results, along time, in the same iteration


clear;clc; close all;
sim_name = '300m_9x9_twoLane_twoDirection_remove1Lane';

if strcmp(sim_name,'PortionOfSC')
aggreResultsPath = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/PortionOfSC/period_1sec/aggregatedResults/';
elseif  strcmp(sim_name,'300m_9x9_twoLane_twoDirection_remove1Lane')
aggreResultsPath = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/300m_9x9_twoLane_twoDirection_remove1Lane/3600vehPerHr/aggregatedResults/';
end
flag_xml2csv = 1;
emptyRoadSpeed = 11.17;
featureKeyWord = 'speed';
fileRegExp = 'bl_seed*2400*.xml';

if 1 == flag_xml2csv
    fcn_xml2csv_fixXML(aggreResultsPath,fileRegExp,sim_name);
    fcn_xml2csv_multipleFiles(aggreResultsPath,fileRegExp);
end



%% case 1: time interval of 60 sec 
close all;
exp1 = 'bl_seed_*_aggreInterval_60aggregated.csv'; % regular expression 1; 
corfignum = 100;
timeInterval = 60;

[h,p,R1_crop,R2_crop,pd1,pd2] = fcn_corrCheckAndTtest(aggreResultsPath,exp1,emptyRoadSpeed,corfignum,timeInterval,featureKeyWord,sim_name);
%% case 2: time interval of 120 sec 
close all;
exp1 = 'bl_seed_*_aggreInterval_120aggregated.csv';
corfignum = 200;
timeInterval = 120;

[h,p,R1_crop,R2_crop,pd1,pd2] = fcn_corrCheckAndTtest(aggreResultsPath,exp1,emptyRoadSpeed,corfignum,timeInterval,featureKeyWord,sim_name);

%% case 3: time interval of 300 sec
close all;
exp1 = 'bl_seed_*_aggreInterval_300aggregated.csv';
corfignum = 300;
timeInterval = 300;

[h,p,R1_crop,R2_crop,pd1,pd2] = fcn_corrCheckAndTtest(aggreResultsPath,exp1,emptyRoadSpeed,corfignum,timeInterval,featureKeyWord,sim_name);

%% case 4: time interval of 600 sec
close all;
exp1 = 'bl_seed_*_aggreInterval_600aggregated.csv';
corfignum = 600;
timeInterval = 600;

[h,p,R1_crop,R2_crop,pd1,pd2] = fcn_corrCheckAndTtest(aggreResultsPath,exp1,emptyRoadSpeed,corfignum,timeInterval,featureKeyWord,sim_name);


%% case 5: time interval of 1200 sec
close all;
exp1 = 'bl_seed_*_aggreInterval_1200aggregated.csv';
corfignum = 1200;
timeInterval = 1200;

[h,p,R1_crop,R2_crop,pd1,pd2] = fcn_corrCheckAndTtest(aggreResultsPath,exp1,emptyRoadSpeed,corfignum,timeInterval,featureKeyWord,sim_name);

%% case 6: time interval of 2400 sec 
close all;
exp1 = 'bl_seed_*_aggreInterval_2400aggregated.csv'; % regular expression 1; 
corfignum = 2400;
timeInterval = 2400;

[h,p,R1_crop,R2_crop,pd1,pd2] = fcn_corrCheckAndTtest(aggreResultsPath,exp1,emptyRoadSpeed,corfignum,timeInterval,featureKeyWord,sim_name);



% 
% %% case 7: time interval of 4800 sec 
% close all;
% exp1 = 'seed_*_aggreInterval_4800_aggregated.csv'; % regular expression 1; 
% corfignum = 4800;
% timeInterval = 4800;
% 
% [h,p,R1_crop,R2_crop,pd1,pd2] = fcn_corrCheckAndTtest(aggreResultsPath,exp1,emptyRoadSpeed,corfignum,timeInterval,featureKeyWord);
% 

