function result = fcn_CorrWithinSim(fileDirectory, fileNameExpress,emptyRoadSpeed,figNum,featureKeyWord)
    
directory = fileDirectory;
files = dir(fullfile(directory, fileNameExpress));

for ii = 1:length(files)
fileName = files(ii).name;    
R_withinSim(ii,:) = fcn_CorrOneSim([directory,fileName],emptyRoadSpeed,featureKeyWord);    
end

mean_col = mean(R_withinSim);
std_col = std(R_withinSim);
upperBD = mean_col + 3*std_col;
lowerBD = mean_col - 3*std_col;
[rowNum,~ ] = size(R_withinSim);
%% PLOTS
% figure(figNum);
% hold on;
% for ii = 1:rowNum
%     h1 = plot(R_withinSim(ii,:),'k','Color',[0.6,0.6,0.6]);  
% end
% h2 = plot(upperBD(:,:),'k','LineWidth',2);
% plot(lowerBD(:,:),'k','LineWidth',2);
% h3 = plot(mean_col(:,:),'b','LineWidth',2);
% xlabel('Time interval number');
% ylabel('Correlation coefficient');
% 
% cls_SUMOplot.fcn_setFigureFormat;
% legend([h1,h2,h3],"Correlation coefficient","99 percentile boundary","Mean");

result.mean_col = mean_col;
result.std_col = std_col;
result.upperBD = upperBD;
result.lowerBD = lowerBD;
result.R = R_withinSim; 




end




function R_oneSim = fcn_CorrOneSim(filePath,emptyRoadSpeed,featureKeyWord)
% This script does the following.

% 1. Check the correlation coefficients between adjacent aggregated results
% along time, in the same iteration

data = readtable(filePath);
data.edge_density = fillmissing(data.edge_density,"constant",0);
data.edge_speed = fillmissing(data.edge_speed,"constant",emptyRoadSpeed);
% Crop the data where the road network is initializing 
% Select this as 600 sec 
timeCrop = 600; 
data = data(data.interval_end>timeCrop,:);
% How many time intervals are there?
intervalNum = unique(data.interval_end);

for ii = 1:length(intervalNum)-1
    ind1 = find(data.interval_end == intervalNum(ii));
    ind2 = find(data.interval_end == intervalNum(ii+1));
    selectedData1 = data(ind1,:);
    selectedData2 = data(ind2,:);    
    if strcmp(featureKeyWord,'density')
    R_temp = corrcoef(selectedData1.edge_density, selectedData2.edge_density);
    elseif strcmp(featureKeyWord,'speed')
    R_temp = corrcoef(selectedData1.edge_speed, selectedData2.edge_speed);   
    end
    R_oneSim(ii) = R_temp(1,2);

end


end

