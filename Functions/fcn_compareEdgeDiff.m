% This function compares two SUMO network file in .net.xml format, and
% output the differences as edge ID.
% INPUT: 
% blEdgeXml: the network file for baseline simulation
% perEdgeXml: the network file for perturbed simulation
% Output:
% edgeDiff: the difference of INPUTS files as edge IDs. 

% Created by: Wushuang Bai
% Revision history:
% 2023 02 01: added comments

function edgeDiff = fcn_compareEdgeDiff(blEdgeXml,perEdgeXml)
bl = readstruct(blEdgeXml);
for ii = 1:length(bl.edge)
    edgeID_bl(ii,1) = bl.edge(ii).idAttribute ;
end

per = readstruct(perEdgeXml);
for ii = 1:length(per.edge)
    edgeID_per(ii,1) = per.edge(ii).idAttribute ;
end

edgeDiff = setdiff(edgeID_bl,edgeID_per)';
fprintf("The following edges are being removed from the perturbation road network \n");
disp(edgeDiff); 
end