function result = fcn_CorrAcrossSim(fileDirectory, fileNameExpress,emptyRoadSpeed,figNum,featureKeyWord)

directory = fileDirectory;
files = dir(fullfile(directory, fileNameExpress));


for ii = 1:length(files)
    filePath = [directory,files(ii).name];
    data = readtable(filePath);
    data.edge_density = fillmissing(data.edge_density,"constant",0);
    data.edge_speed = fillmissing(data.edge_speed,"constant",emptyRoadSpeed);
    timeCrop = 600; 
    data = data(data.interval_end>timeCrop,:);
    dataCell{ii} = data;
    clear data; 
end

% How many time intervals are there?
intervalNum = unique(dataCell{1}.interval_end);

% Outer loop: loop through time intervals 
for kk = 1:length(intervalNum)
pickTime = intervalNum(kk);
% Inner loop: loop through 
for ii = 1:length(dataCell)-1
    ind1 = find(dataCell{ii}.interval_end == pickTime);
    ind2 = find(dataCell{ii+1}.interval_end == pickTime);
    selectedData1 = dataCell{ii}(ind1,:);
    selectedData2 = dataCell{ii+1}(ind2,:);  
    if strcmp(featureKeyWord,'density')
    R_temp = corrcoef(selectedData1.edge_density, selectedData2.edge_density);
    elseif strcmp(featureKeyWord,'speed')
    R_temp = corrcoef(selectedData1.edge_speed, selectedData2.edge_speed);
    end
    R(ii,kk) = R_temp(1,2);

end
end
mean_col = mean(R,2);
std_col = std(R,0,2);
upperBD = mean_col + 3*std_col;
lowerBD = mean_col - 3*std_col;

%% PLOTS

% for ii = 1:length(R)
% figure(figNum);
% hold on; 
% h1 = plot(R(:,ii),'k','color',[0.6,0.6,0.6]);
% xlabel('Simulation iteration ID');
% ylabel('Correlation coefficient');
% end
% 
% h2 = plot(upperBD,'k','LineWidth',2);
% plot(lowerBD,'k','LineWidth',2);
% h3 = plot(mean_col,'b','LineWidth',2);
% cls_SUMOplot.fcn_setFigureFormat;
% legend([h1,h2,h3],"Correlation coefficient","99th percentile boundary","Mean");

result.mean_col = mean_col;
result.std_col = std_col;
result.upperBD = upperBD;
result.lowerBD = lowerBD;
result.R = R; 


end