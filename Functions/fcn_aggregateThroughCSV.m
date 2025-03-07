function outputData = fcn_aggregateThroughCSV(directory,fileRegExpress,emptySpeed)

files = dir(fullfile(directory, fileRegExpress));
for ii = 1:length(files)
data = readtable(fullfile(directory,files(ii).name));
data.edge_density = fillmissing(data.edge_density,'constant',0);
data.edge_speed = fillmissing(data.edge_speed,'constant',emptySpeed);
allDensity(:,ii) = data.edge_density;
allSpeed(:,ii) = data.edge_speed;
end

aggregatedData.interval_begin = data.interval_begin;
aggregatedData.interval_end = data.interval_end;
aggregatedData.edge_density = mean(allDensity,2);
aggregatedData.edge_speed = mean(allSpeed,2);
aggregatedData.edge_id = data.edge_id; 

outputData = struct2table(aggregatedData);
end