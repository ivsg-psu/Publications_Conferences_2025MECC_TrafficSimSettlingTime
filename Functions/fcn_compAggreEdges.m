function tTestResult = fcn_compAggreEdges(blAggregated,perAggregated,featureKeyWord,alpha)

% This function compares densities of aggregated results of edges from baseline and
% perturbed simulations using paired t test.
% INPUTS:
% bl_aggregatedFile: the aggregated edge-based measurements from baseline,
% in csv format
% per_aggregatedFile: the aggregaed edge-based measurements from
% perturbed, in csv format

% OUTPUTS:
% table that contains the following columns:
% edge_name: the name of the edge, in string
% h: the result of t test. 1:  rejects the null hypothesis at the 5% significance level, and 0 otherwise.
% p: the p-value

% Revision history:
% 20230312 first write of code
% 20231030 edit fill missing
% 20231126 removed unnecessary comments




temp = find(perAggregated.interval_begin==0);
edgeID = perAggregated.edge_id(temp);
result = cell(length(edgeID),1);
for ii = 1:length(edgeID)
    % find edgeID in bl and per
    ind_bl = find(strcmp(edgeID(ii),blAggregated.edge_id));
    ind_per = find(strcmp(edgeID(ii),perAggregated.edge_id));
    % pick data 
    if strcmp(featureKeyWord,'density')
    feature_bl = blAggregated.edge_density(ind_bl);    
    feature_per = perAggregated.edge_density(ind_per);
    
    elseif strcmp(featureKeyWord,'speed')
    feature_bl = blAggregated.edge_speed(ind_bl);    
    feature_per = perAggregated.edge_speed(ind_per);
    end
    % compare
    [h,p] = ttest(feature_bl,feature_per,'Alpha',alpha);
    % output into a cell
    result{ii}.edgeID = edgeID(ii);
    result{ii}.feature_bl = feature_bl;
    result{ii}.feature_per = feature_per; 
    result{ii}.h = h;
    result{ii}.pvalue = p; 

end

tTestResult = result;

end











