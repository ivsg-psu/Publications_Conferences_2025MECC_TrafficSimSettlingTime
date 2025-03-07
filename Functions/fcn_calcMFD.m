function MFD = fcn_calcMFD(aggregated_file_name, edge_length, interval)
% This function calculates the Macroscopic Fundamental Diagram of a ROAD NETWORK. 

% INPUTS:
% aggregated_file_name: the file name of the aggregated edge measurements
% in csv format
% edge_length: the leng of each edge, in the homogeneous grid network,
% meters
% interval: the measurement interval, seconds 

% Outputs: 
% A struct, which contains the flow, and density.

% Reference: 
% Qiong Lu, Tamás Tettamanti, Dániel Hörcher & István Varga (2020)
%The impact of autonomous vehicles on urban traffic network capacity: an experimental
%analysis by microscopic traffic simulation, Transportation Letters, 12:8, 540-549, DOI:
%10.1080/19427867.2019.1662561

% Revision history: 
% 2023 02 20: first write of code


% Read in the data
data = readtable(aggregated_file_name);
%% Remove NaN values by filling in 0 
ind_nan = find(isnan(data.edge_density)); %usually nan appears firstly in edge_density,edge_lanedensity, edge_occupancy...
% edge_overlaptraveltime,edge_speed,edge_speedrelative,edge_timeLoss,edge_traveltime,edge_waitingtime
columnToFill = {'edge_density','edge_laneDensity','edge_occupancy','edge_overlapTraveltime','edge_speed','edge_speedRelative',...
    'edge_timeLoss','edge_traveltime','edge_waitingTime'};
for ii = 1:length(columnToFill)
    data(ind_nan,:).(columnToFill{ii}) = zeros(length(ind_nan),1);
end

%% compute MFD
edgeLength = edge_length/1000; % Your length of one edge, km.
intervalID = unique(data.interval_begin);
finalQ = zeros(length(intervalID),1);
finalRho = zeros(length(intervalID),1);

for ii = 1:length(intervalID)
indInterval = find(data.interval_begin == intervalID(ii));
intervalData = data(indInterval,:); 
intervalVehicleTotalNumber = sum(intervalData.edge_sampledSeconds/interval); 
intervalEdgeTotalLength = edgeLength * height(intervalData); 
intervalRho = intervalVehicleTotalNumber/intervalEdgeTotalLength;
intervalQ = sum(3.6 * intervalData.edge_speed .* intervalData.edge_density);
finalQ(ii) = intervalQ;
finalRho(ii) = intervalRho; 
clear intervalRho intervalQ; 
end
%% output as a truct 
MFD.Q = finalQ; % flow
MFD.Rho = finalRho; % density
g = fittype('a*x^3 + b*x^2 + c*x + 0'); % fitting the data as a curve
fitobj = fit(MFD.Rho,MFD.Q,g,'StartPoint', [0,0,0]); % curve fit
MFD.fitobj = fitobj; % output the fit

end


