function fcn_plotRoadNetworkWithTTest(edgeFile,nodeFile,tTestResult,offset,figureNum)
% This function plot a road network.
% INPUTS:
% edgeFile: the path to the edge file in csv, string
% nodeFile: the path to the node file in csv, string
% ttestStruct: the struct that stores the results of t test
% figureNum: the figure number to plot the road network
% offset: the offset to plot left and right lanes, from the center line,
% meters. 
% NOTE: offset is usually a minus number, to make it proper for the
% directions.

%% read in edge information

edges = readstruct(edgeFile);
edges = edges.edge;
for ii = 1:length(edges)
    edges(ii).fromAttribute = string(edges(ii).fromAttribute);
    edges(ii).toAttribute = string(edges(ii).toAttribute);
    edges(ii).idAttribute = string(edges(ii).idAttribute);
end



%% read in node information
nodes = readstruct(nodeFile);
nodes = nodes.node;
for ii = 1:length(nodes)
nodes(ii).idAttribute = string(nodes(ii).idAttribute);

end

%%
% read in connection information
% connections = readtable(connectionFile);
% figureNum = 100;
% offset = 2;
% create empty plot
 

for ii = 1:length(tTestResult)
    edgeID =tTestResult{ii}.edgeID;
    for jj = 1:length(edges)
    if edgeID{1} == edges(jj).idAttribute
    ind = jj;
    break;
    end
    end
    
    fromNodeID = edges(ind).fromAttribute;
    toNodeID = edges(ind).toAttribute;  
    for jj = 1:length(nodes)
    if fromNodeID == nodes(jj).idAttribute
    fromX = nodes(jj).xAttribute;
    fromY = nodes(jj).yAttribute;
    end
    
    if toNodeID == nodes(jj).idAttribute
    toX = nodes(jj).xAttribute;
    toY = nodes(jj).yAttribute;
    end
    end
    fromXY = [fromX,fromY];
    toXY = [toX,toY];

    if 1 == tTestResult{ii}.h
        fcn_plotEdge(fromXY,toXY,offset,figureNum,'r');
    else
        fcn_plotEdge(fromXY,toXY,offset,figureNum,'k');
    end

end



%% plot connections
for ii = 1:length(nodes)
    xcoor = nodes(ii).xAttribute;
    ycoor = nodes(ii).yAttribute;
    plot(xcoor,ycoor,'ko','markersize',5,'markerfacecolor','k');

end

% add labels to the plot
xlabel('X position (meters)');
ylabel('Y position (meters)');
axis auto;

end

