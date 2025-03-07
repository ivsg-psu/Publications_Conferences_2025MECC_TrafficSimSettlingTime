% This script read the aggregated simulation data generated through
% different traffic volume inputs, and generate cumulative mean and
% cumulative standard deviation.

% 20240911: added comments

close all;
emptySpeed = 11.17;
sim_name = '300m_9x9_twoLane_twoDirection_remove1Lane';
%sim_name = 'PortionOfSC';
if strcmp(sim_name,'PortionOfSC')
directoryList = {'./SUMO/PortionOfSC/1800vehPerHr/aggregatedResults/'....
    './SUMO/PortionOfSC/3600vehPerHr/aggregatedResults/',...
    './SUMO/PortionOfSC/7200vehPerHr/aggregatedResults/',...
    './SUMO/PortionOfSC/10800vehPerHr/aggregatedResults/',...
    './SUMO/PortionOfSC/14400vehPerHr/aggregatedResults/',...
    './SUMO/PortionOfSC/18000vehPerHr/aggregatedResults/'};

elseif strcmp(sim_name, '300m_9x9_twoLane_twoDirection_remove1Lane')
directoryList = {'./SUMO/300m_9x9_twoLane_twoDirection_remove1Lane/1800vehPerHr/aggregatedResults/',...
    './SUMO/300m_9x9_twoLane_twoDirection_remove1Lane/3600vehPerHr/aggregatedResults/',...
    './SUMO/300m_9x9_twoLane_twoDirection_remove1Lane/7200vehPerHr/aggregatedResults/',...
    './SUMO/300m_9x9_twoLane_twoDirection_remove1Lane/10800vehPerHr/aggregatedResults/',...
    './SUMO/300m_9x9_twoLane_twoDirection_remove1Lane/14400vehPerHr/aggregatedResults/',...
    './SUMO/300m_9x9_twoLane_twoDirection_remove1Lane/18000vehPerHr/aggregatedResults/'};

end
for jj = 1:length(directoryList)

directory = directoryList{jj}; 
files = dir(fullfile(directory, 'bl_seed_1_aggreInterval_60aggregated.csv'));                                 
dataField = 'edge_speed';

for ii = 1:length(files)
    filePath = [directory,files(ii).name];
    [h1{jj},h2{jj},intervalNum_hour{jj},dataMean{jj}] = fcn_MeanAndVar(filePath,dataField,1,2,emptySpeed);
    
end
end

%% plots 
f1 = figure(1);
hline1 = yline(emptySpeed,'k--','LineWidth',2);
legend([h1{1},h1{2},h1{3},h1{4},h1{5},h1{6},hline1],'1800 veh/hr','3600 veh/hr','7200 veh/hr', ...
    '10800 veh/hr','14400 veh/hr','18000 veh/hr','Free flow speed');
xlim([0 3]);
cls_SUMOplot.fcn_setFigureFormat;
print(f1,[pwd,'/Fig/',sim_name,'_mean_',dataField,'multipleTrafficVolume'],'-dpng','-r300');

f2 = figure(2);
legend([h2{1},h2{2},h2{3},h2{4},h2{5},h2{6}],'1800 veh/hr','3600 veh/hr','7200 veh/hr', ...
    '10800 veh/hr','14400 veh/hr','18000 veh/hr');
xlim([0 3]);
cls_SUMOplot.fcn_setFigureFormat;
print(f2,[pwd,'/Fig/',sim_name,'_STD_',dataField,'multipleTrafficVolume'],'-dpng','-r300');




