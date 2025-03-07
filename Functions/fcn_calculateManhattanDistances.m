function manhattan_distances = fcn_calculateManhattanDistances(nodefilepath, edgefilepath, simname)
    % Define the center of the map based on the simulation name
    if strcmp(simname, '300m_9x9_twoLane_twoDirection_remove1Lane')
         mapCenter = [1200, 1200];
    elseif strcmp(simname, 'PortionOfSC')
         mapCenter = [787.07, 486.535];
    end
    
    % Read the node and edge XML files using readstruct
    nodeData = readstruct(nodefilepath);
    edgeData = readstruct(edgefilepath);
    
    % Initialize dictionary for node coordinates
    nodeMap = dictionary(); 
    
    % Fill nodeMap with node coordinates
    nodes = nodeData.node;
    for i = 1:length(nodes)
        nodeID = nodes(i).idAttribute;
        xCoord = nodes(i).xAttribute;
        yCoord = nodes(i).yAttribute;
        nodeMap(nodeID) = struct('x', xCoord, 'y', yCoord);
    end
    
    % Initialize dictionary for storing Manhattan distances
    manhattan_distances = dictionary();
    
    % Loop over each edge and calculate Manhattan distance
    edges = edgeData.edge;
    for i = 1:length(edges)
        edgeID = edges(i).idAttribute;
        fromNode = edges(i).fromAttribute;
        toNode = edges(i).toAttribute;
        
        % Retrieve coordinates of fromNode and toNode
        if isKey(nodeMap, fromNode) && isKey(nodeMap, toNode)
            fromCoord = nodeMap(fromNode);
            toCoord = nodeMap(toNode);
            
            % Calculate the midpoint of the edge
            midPoint.x = (fromCoord.x + toCoord.x) / 2;
            midPoint.y = (fromCoord.y + toCoord.y) / 2;
            
            % Calculate the Manhattan distance to the map center
            manhattan_distance = abs(midPoint.x - mapCenter(1)) + abs(midPoint.y - mapCenter(2));
            
            % Store the Manhattan distance for the edge
            manhattan_distances(edgeID) = manhattan_distance;
        end
    end
    
    % Display the calculated Manhattan distances
    disp(manhattan_distances);
end
