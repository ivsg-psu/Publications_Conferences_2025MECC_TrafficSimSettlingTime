function edgeWithMaxManhattan = fcn_findMaxManhattanDistance(edgeLocations, t_test_results,simname)
    % Define the center of the map
    if strcmp(simname,'300m_9x9_twoLane_twoDirection_remove1Lane')
         mapCenter = [1200 1200];;
    elseif strcmp(simname,'PortionOfSC')
         mapCenter = [787.0700  486.5350];
    end
    
    % Initialize a structure to store the result for each time step
    edgeWithMaxManhattan = struct();
    
    % Get the edge IDs from the t_test_results
    edges = fieldnames(t_test_results);
    
    % Loop through each time step
    for t = 1:length(t_test_results.(edges{1}))
        % Initialize variables for storing maximum distance and corresponding edge
        maxDistance = -inf; % Start with negative infinity
        edgeWithMaxDistance = '';
        
        % Loop through each edge
        for i = 1:length(edges)
            edgeID = edges{i};
            
            % Check if h value is 1 at this time step
            if t_test_results.(edgeID)(t).h == 1
                % Get the edge's midpoint (location) from edgeLocations
                if isfield(edgeLocations, edgeID)
                    edgeMidPoint = edgeLocations.(edgeID).midPoint;
                    
                    % Calculate the Manhattan distance to the map center
                    distance = abs(edgeMidPoint(1) - mapCenter(1)) + abs(edgeMidPoint(2) - mapCenter(2));
                    
                    % Check if this is the maximum distance found so far
                    if distance > maxDistance
                        maxDistance = distance;
                        edgeWithMaxDistance = edgeID;
                    end
                end
            end
        end
        
        % Store the result for this time step
        edgeWithMaxManhattan(t).edgeID = edgeWithMaxDistance;
        edgeWithMaxManhattan(t).distance = maxDistance;
    end
    
    % Display the results
    disp('Edges with max Manhattan distance at each time step:');
    disp(edgeWithMaxManhattan);
end
