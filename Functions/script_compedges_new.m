
% Get edge locations and add the h value from the t-test results
% edgeLocations = getEdgeLocationsWithH(nodeFilePath, edgeFilePath, t1);
% manhattan_distances = calculateManhattanDistances(edgeLocations);
% Assuming you have edgeLocations and t_test_results ready


blFiles  = dir(fullfile(aggreResultsPath,'bl_seed_*_aggreInterval_300aggregated.csv'));
perFiles = dir(fullfile(aggreResultsPath,'per_seed_*_aggreInterval_300aggregated.csv'));
edgesManhattanDis = fcn_calculateManhattanDistances(nodeFilePath,edgeFilePath,sim_name);
exampledata = readtable(fullfile(blFiles(1).folder,blFiles(1).name));
time = unique(exampledata.interval_end);

% for ii = 1:length(blFiles)
% currentblFile = fullfile(blFiles(ii).folder,blFiles(ii).name);
% currentperFile = fullfile(perFiles(ii).folder,perFiles(ii).name);
% t1 = fcn_paired_t_test_edge_speed_time(currentblFile,currentperFile);
% currentPairKey = vertcat(t1.keys)
% currentPairH   = vertcat(t1.values.h)
% currentPairH2  = fillmissing(currentPairH,'constant',0)
% for jj = 1:width(currentPairH2)
%     currentTimeH = currentPairH2(:,jj);
%     ind = find(currentTimeH == 1);
%     currentTimeDis = dis1.entries.Value(ind,:)
%     Dis(jj) = max(currentTimeDis);
% end
% ROI_all(ii,:) = Dis;
% clear Dis; 
% end
ROI_all = {};
for ii = 1:length(blFiles)
currentblFile = fullfile(blFiles(ii).folder,blFiles(ii).name);
currentperFile = fullfile(perFiles(ii).folder,perFiles(ii).name);
tResults{ii} = fcn_paired_t_test_edge_speed_time(currentblFile,currentperFile);
for jj = 1:length(tResults{ii}.keys)
   currentkey = tResults{ii}.keys{jj}
   temp = nan(size(tResults{ii}(currentkey).h));
   temp(tResults{ii}(currentkey).h==1) = edgesManhattanDis(currentkey);
   temp(tResults{ii}(currentkey).h~=1) = nan;
   tResults{ii}(currentkey).roi_t = temp;
   roi_temp(jj,:) = temp;
end
ROI_all{ii} = roi_temp;
clear roi_temp;
end
ROI_all = vertcat(ROI_all{:});

figure();
h = boxplot(ROI_all);
xticklabels(round(time(2:end)/3600,2));
ylabel('Manhattan distance (m)');
xlabel('Time (hr)');
set(findobj(h, 'Tag', 'Median'), 'LineWidth', 2);
cls_SUMOplot.fcn_setFigureFormat;
print(gcf,fullfile(figPath,'ROI'),'-dpng','-r300')

figure()
plot(time(2:end)/3600,ROI_all)
hold on;
ROImean = mean(ROI_all,'omitmissing');



% SD = std(ROI_all)
% upperBD = ROImean + 2 * SD;
% lowerBD = ROImean - 2 * SD;
% 
% 
% figure;
% for ii = 1:height(ROI_all)
%     figure(10010);
%     hold on;
%     plot(time(2:end)'/3600,ROI_all(ii,:),'-');
% end
% %%
plot(time(2:end)/3600,ROImean,'r','LineWidth',2);
% plot(time(2:end)/3600,upperBD,'b','LineWidth',2);
% plot(time(2:end)/3600,lowerBD,'b','LineWidth',2);



%%%%%%%%%%%%%%%%%% Functions %%%%%%%%%%%%%%%%%%%%%%%%
% Function to perform paired t-test and store the results

% Function to get edge locations and add the h values from t-test results
function edgeLocations = getEdgeLocationsWithH(nodeFile, edgeFile, t_test_results)
    % Read the node and edge XML files using readstruct
    nodeData = readstruct(nodeFile);
    edgeData = readstruct(edgeFile);
    
    % Initialize the dictionary for node coordinates
    nodeMap = dictionary();
    
    % Extract node coordinates and store in the dictionary
    nodes = nodeData.node;
    for i = 1:length(nodes)
        % Use idAttribute, xAttribute, and yAttribute
        nodeID = nodes(i).idAttribute;
        xCoord = nodes(i).xAttribute;
        yCoord = nodes(i).yAttribute;
        nodeMap(nodeID) = {[xCoord, yCoord]};
    end
    
    % Extract edge data and compute midpoints
    edges = edgeData.edge;
    edgeLocations = struct();
    
    for i = 1:length(edges)
        fromNode = edges(i).fromAttribute;
        toNode = edges(i).toAttribute;
        edgeID = edges(i).idAttribute;
        
        % Check if both nodes exist in the dictionary
        if isKey(nodeMap, fromNode) && isKey(nodeMap, toNode)
            fromCoord = nodeMap(fromNode);
            toCoord = nodeMap(toNode);
            
            % Calculate the midpoint
            midPoint = (fromCoord{1} + toCoord{1}) / 2;
            
            % Check if the edge exists in the t-test results and add the h value
            if isfield(t_test_results, edgeID)
                % Assume the last h value from the t-test results is what you want
                h_value = t_test_results.(edgeID)(1:end).h;
            else
                h_value = NaN; % If the edge is not found in the t-test results
            end
            
            % Store the edge midpoint and the h value
            edgeLocations.(edgeID) = struct('midPoint', midPoint, 'h_value', h_value);
        end
    end
    
    % Display the results
    disp(edgeLocations);
end


