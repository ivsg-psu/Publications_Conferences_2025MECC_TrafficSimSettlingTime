%% case 1: time interval of 60 sec

clear;clc; close all;
directory = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/TimeIntervalTests/period_0.1sec/aggregatedResults/';
exp1 = 'seed_*_interval_60bl_aggregated60.csv';
fignum = 101;
fcn_CorrAcrossSim(directory,exp1,fignum);
print(gcf,'60sec_across','-dpng');


%% case 2: time interval of 120 sec 
clear;clc; close all;
directory = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/TimeIntervalTests/period_0.1sec/aggregatedResults/';
exp1 = 'seed_*_interval_120bl_aggregated120.csv';
fignum = 101;
fcn_CorrAcrossSim(directory,exp1,fignum);

%% case 3: time interval of 300 sec
clear;clc; close all;
directory = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/TimeIntervalTests/period_0.1sec/aggregatedResults/';
exp1 = 'seed_*_interval_300bl_aggregated300.csv';
fignum = 101;
fcn_CorrAcrossSim(directory,exp1,fignum);


%% case 4: time interval of 600 sec
clear;clc; close all;
directory = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/TimeIntervalTests/period_0.1sec/aggregatedResults/';
exp1 = 'seed_*_interval_600bl_aggregated600.csv';
fignum = 101;
fcn_CorrAcrossSim(directory,exp1,fignum);


%% case 5: time interval of 1200 sec
clear;clc; close all;
directory = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/TimeIntervalTests/period_0.1sec/aggregatedResults/';
exp1 = 'seed_*_interval_1200bl_aggregated1200.csv';
fignum = 101;
fcn_CorrAcrossSim(directory,exp1,fignum);