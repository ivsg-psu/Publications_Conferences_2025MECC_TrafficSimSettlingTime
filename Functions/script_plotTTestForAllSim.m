% This script takes all the t test struct as inputs, and do a bar plot for
% the results.

% Revision history: 
% 20230506 first write of the code

%sim_name = '300m_9x9_twoLane_twoDirection_remove1Lane';   
sim_name = 'PortionOfSC';
SUMOFilePath = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/';
dataPath = strcat(SUMOFilePath,sim_name,'/Data');
periodOptions = [1,0.5,0.2,0.1,0.05,0.02];
figNum = 100;
cls_SUMOplot.fcn_tTestBarPlot(periodOptions,dataPath,figNum);
cls_SUMOplot.fcn_setFigureFormat;
figPath = [SUMOFilePath,sim_name,'/Fig'];
figPath = strcat(figPath,'/tTestBar');
print(gcf,figPath,'-dpng');