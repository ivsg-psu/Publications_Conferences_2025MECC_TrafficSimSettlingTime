function fcn_plotRoadNetworkWithTTest(edgeFile,nodeFile,ttestStruct,offset,figureNum)
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
edges = readtable(edgeFile);
edges.edge_from = string(edges.edge_from);
edges.edge_to = string(edges.edge_to);


%% read in node information
nodes = readtable(nodeFile);
nodes.node_id = string(nodes.node_id);
% read in connection information
% connections = readtable(connectionFile);

% create empty plot
figure(figureNum);
hold on;

% loop over edges and plot them
% for ii = 1:size(edges, 1)
%     fromXY = nodes(strcmp(edges.edge_from(ii), nodes.node_id), {'node_x', 'node_y'});
%     toXY = nodes(strcmp(edges.edge_to(ii), nodes.node_id), {'node_x', 'node_y'});
%     fcn_plotEdge(fromXY,toXY,offset,figureNum);
%
% end

for ii = 1:size(ttestStruct)
    edgeID = ttestStruct{ii}.edgeID;
    ind1 = strcmp(edgeID,edges.edge_id); % Get the row index for this Edge ID
    fromXY = nodes(strcmp(edges(ind1,:).edge_from,nodes.node_id),{'node_x', 'node_y'});
    toXY = nodes(strcmp(edges(ind1,:).edge_to,nodes.node_id),{'node_x', 'node_y'});

    if 1 == ttestStruct{ii}.h
        fcn_plotEdge(fromXY,toXY,offset,figureNum,'r');
    else
        fcn_plotEdge(fromXY,toXY,offset,figureNum,'k');
    end


end





%% plot connections
for ii = 1:size(nodes,1)
    xcoor = nodes(ii,:).node_x;
    ycoor = nodes(ii,:).node_y;
    plot(xcoor,ycoor,'ko','markersize',5,'markerfacecolor','k');

end

% add labels to the plot
xlabel('X[m]');
ylabel('Y[m]');

axis auto;

fwidth=800;%
fheight=800;%
fright=100;%
fbottom=400;%
set(gcf,'position',[fright,fbottom,fwidth,fheight],'color','w');
% Settings properties for axes
axes_handle = gca;
set(axes_handle, 'FontName', 'Times New Roman', 'FontSize', 12,'LineWidth',1.5);
box on;
print([pwd,'roadNetworkWithTTest','-dpng']);


end