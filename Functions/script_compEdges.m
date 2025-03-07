
% Get edge locations and add the h value from the t-test results
% edgeLocations = getEdgeLocationsWithH(nodeFilePath, edgeFilePath, t1);
% manhattan_distances = calculateManhattanDistances(edgeLocations);
% Assuming you have edgeLocations and t_test_results ready


blFiles  = dir(fullfile(aggreResultsPath,'bl_seed_*_aggreInterval_300aggregated.csv'));
perFiles = dir(fullfile(aggreResultsPath,'per_seed_*_aggreInterval_300aggregated.csv'));

for ii = 1:length(blFiles)
    currentblFile = fullfile(blFiles(ii).folder,blFiles(ii).name);
    currentperFile = fullfile(perFiles(ii).folder,perFiles(ii).name);
    t_test_results{ii} = fcn_paired_t_test_edge_speed_time(currentblFile,currentperFile);  
    edgeLocations{ii} = getEdgeLocationsWithH(nodeFilePath, edgeFilePath, t_test_results{ii});
end

for ii = 1:length(t_test_results)
    edgeWithMaxManhattan{ii} = fcn_findMaxManhattanDistance(edgeLocations{ii}, t_test_results{ii},sim_name);
end

data = readtable(currentblFile)
time = unique(data.interval_end);

for ii = 1:length(edgeWithMaxManhattan)
    ROI_all(ii,:) = vertcat(edgeWithMaxManhattan{ii}.distance)';
end
ROImean = mean(ROI_all);
SD = std(ROI_all)
upperBD = ROImean + 2 * SD;
lowerBD = ROImean - 2 * SD;

%%
figure;
for ii = 1:length(edgeWithMaxManhattan)
    figure(10010);
    hold on;
    plot(time(2:end)'/3600,ROI_all(ii,:),'-');    
end
%%
plot(time(2:end)/3600,ROImean,'r','LineWidth',2);
plot(time(2:end)/3600,upperBD,'b','LineWidth',2);
plot(time(2:end)/3600,lowerBD,'b','LineWidth',2);



%%%%%%%%%%%%%%%%%% Functions %%%%%%%%%%%%%%%%%%%%%%%%
% Function to perform paired t-test and store the results
function t_test_results = fcn_paired_t_test_edge_speed_time(bl_data, per_data)
    % Load the data from the CSV files
    bl_data = readtable(bl_data, 'Delimiter', ';');
    per_data = readtable(per_data, 'Delimiter', ';');
    
    % Initialize a structure to store t-test results
    t_test_results = struct();
    
    % Get the unique edges
    edges = unique(bl_data.edge_id);
    
    % Perform paired t-test for each edge as a function of time
    for i = 1:length(edges)
        edge = edges{i};
        bl_edge_speed = bl_data.edge_speed(strcmp(bl_data.edge_id, edge));
        per_edge_speed = per_data.edge_speed(strcmp(per_data.edge_id, edge));
        
        % Initialize a list to store t-test results for different sample sizes
        t_test_results.(edge) = [];
        
        % Perform t-tests for increasing sample sizes
        for j = 2:length(bl_edge_speed)
            bl_samples = bl_edge_speed(1:j);
            per_samples = per_edge_speed(1:j);
            
            % Perform paired t-test
            [h, p, ci, stats] = ttest(bl_samples, per_samples);
            
            % Handle nan values by setting t-statistic and h to 0
            if isnan(stats.tstat)
                stats.tstat = 0;
                h = 0;
            end
            
            % Store the results in the list
            t_test_results.(edge) = [t_test_results.(edge); struct('sample_size', j, 't_stat', stats.tstat, 'p_value', p, 'h', h)];
        end
    end
    
    % Display the t-test results for each edge as a function of time
    edges = fieldnames(t_test_results);
    for i = 1:length(edges)
        edge = edges{i};
        fprintf('Edge: %s\n', edge);
        for j = 1:length(t_test_results.(edge))
            result = t_test_results.(edge)(j);
            fprintf('Sample Size: %d, t-statistic: %.3f, p-value: %.3f, h: %d\n', result.sample_size, result.t_stat, result.p_value, result.h);
        end
    end
end

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

function manhattan_distances = calculateManhattanDistances(edgeLocations,simname)
 
    if strcmp(simname,'300m_9x9_twoLane_twoDirection_remove1Lane')
         mapCenter = [1200 1200];;
    elseif strcmp(simname,'PortionOfSC')
         mapCenter = [787.0700  486.5350];
    end
    % Define the center of the map
   
    
    % Initialize a structure to store Manhattan distances for each edge
    manhattan_distances = struct();
    
    % Get the edge IDs from the edgeLocations
    edges = fieldnames(edgeLocations);
    
    % Loop through each edge
    for i = 1:length(edges)
        edgeID = edges{i};
        
        % Get the edge's midpoint (location) from edgeLocations
        edgeMidPoint = edgeLocations.(edgeID).midPoint;
        
        % Calculate the Manhattan distance to the map center
        distance = abs(edgeMidPoint(1) - mapCenter(1)) + abs(edgeMidPoint(2) - mapCenter(2));
        
        % Store the Manhattan distance for the edge
        manhattan_distances.(edgeID) = distance;
    end
    
    % Display the results
    disp(manhattan_distances);
end

