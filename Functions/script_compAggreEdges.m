% This script compares densities of aggregated results of edges from baseline and
% perturbed simulations using paired t test.
% For details, see fcn_compAggreEdges.m

% Revision history:
% 20230313 first write of code
% 20230414 add function to plot the road network with t test results
% 20231030 remove code to rename csv files, since it's already renamed when
% being generated, using prefix

close all;
emptySpeed = 11.17;
alpha = 0.05;
csvRegExpression.bl = ['bl_seed_*_aggreInterval_',aggreInterval{1},'aggregated.csv'];
csvRegExpression.per = ['per_seed_*_aggreInterval_',aggreInterval{1},'aggregated.csv'];

aggregatedData.bl = fcn_aggregateThroughCSV(aggreResultsPath,csvRegExpression.bl,emptySpeed);
aggregatedData.per = fcn_aggregateThroughCSV(aggreResultsPath,csvRegExpression.per,emptySpeed);
tTestResult = fcn_compAggreEdges(aggregatedData.bl,aggregatedData.per,'density',alpha); 
% clean data, put a 0 to NaN in h. NaN is found when the x and y data are
% identical, see https://www.mathworks.com/matlabcentral/answers/327149-ttest-nan-result-is-nan-and-i-am-a-beginner

%run fcn_fixNumNoice_PortionOfSC.m;

cls_SUMOplot.fcn_plotTTestHist(tTestResult,figPath,flag.period);
fcn_plotRoadNetworkWithTTest(edgeFilePath,nodeFilePath,tTestResult,10,20);



% set plot format
fwidth=1000;%
fheight=800;%
fright=500;%
fbottom=400;%
set(gcf,'color','w','Position',[fright,fbottom,fwidth,fheight]);
if strcmp(sim_name,'PortionOfSC')
% Settings properties for axes
axes_handle = gca;
set(axes_handle, 'FontName', 'Times New Roman', 'FontSize', 12,'LineWidth',1.5);
box on; 
axis ([0 2500 0 2100]);   
end
print(gcf,strcat(figPath,'/PerturbedRoad_',FR,'vehPerHr_aggreInterval',aggreInterval{1}),'-dsvg');

%% calculate ROSI

impactedEdge = fcn_findImpactedEdge(edgeFilePath,nodeFilePath,tTestResult);



%%
ROSI = fcn_calROSI(impactedEdge,sim_name);


% Functions 
function impactedEdge = fcn_findImpactedEdge(edgeFile,nodeFile,tTestResult)
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
impactedEdge = [];
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
        disp('found');
       %impactedEdge(end+1).edgeID = edgeID;
       impactedEdge(end+1,:)= [fromX + toX,fromY + toY]/2;
    end
end
end

function ROSI = fcn_calROSI(impactedEdge,sim_name)
if strcmp(sim_name,'PortionOfSC')
perCoor = [787.0700  486.5350];
elseif  strcmp(sim_name,'300m_9x9_twoLane_twoDirection_remove1Lane')
perCoor = [1200 1200];
end

manhattanDis = abs((impactedEdge(:,1) - perCoor(1)) + (impactedEdge(:,2) - perCoor(2)))

ROSI = max(manhattanDis);

end




