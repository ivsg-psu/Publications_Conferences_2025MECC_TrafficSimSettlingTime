function fcn_plotEdge(nodeFrom, nodeTo,offset,figureNum,color)
% This function plots a SUMO edge by offsetting from a center line formed
% by the path using nodeFrm and nodeTo
% nodeFrom: [x,y]. This is the starting node
% nodeTo: [x,y]. This is the ending node

% Revision history:
% 20230419 editing the code to work with xml file.



% path1 = [
% nodeFrom.node_x,nodeFrom.node_y;
% nodeTo.node_x,nodeTo.node_y];   

path1 = [
nodeFrom;
nodeTo];   


referenceTraversal = fcn_Path_convertPathToTraversalStructure(path1);
offsetTraversal = fcn_Path_fillOffsetTraversalsAboutTraversal(referenceTraversal,offset);

figure(figureNum);
hold on;
plot(offsetTraversal.traversal{1}.X,offsetTraversal.traversal{1}.Y,color,'LineWidth',2);

end