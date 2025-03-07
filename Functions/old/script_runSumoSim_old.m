% This script runs SUMO simulation, output FCD data to xml, and then
% convert the data to csv format.

% potential things to change: 
% speed dev, vehicle insertion rate

clear;clc;close all;
%% define the flags
flag_generate_trip = 0
flag_run_sim = 1

% check OS
if ispc
    SUMO_tool_path = 'F:\Code\tools\';
    des_dir = 'C:\Users\ccctt\OneDrive - The Pennsylvania State University\Documents\GitHub\ThesisWork\SUMO\Temp\';
    python = 'python ';
elseif isunix
    SUMO_tool_path = '/media/wushuang/SeagateMac/Code/tools/';
    des_dir = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/Temp/';
    python = 'python3 ';
end
% execution
% what file to run
sim_name = 'temp';
prefix = ['bl','per'];

% define files to use
% baseline net file
net_file.bl = strcat('bl_',sim_name,'.net.xml');
% perturbed net file
net_file.per = strcat('per_',sim_name,'.net.xml');
% trip file 
trip_file.bl = strcat('bl_',sim_name,'.trips.xml');
trip_file.per = strcat('per_',sim_name,'.trips.xml');
% generate random trips 
com_generate_trip.bl = [python,SUMO_tool_path,'randomTrips.py',' -o ',trip_file.bl,...
    ' -n ',des_dir,net_file.bl,' -e ','3600 ','--weights-output-prefix ','bl_weights'];
com_generate_trip.per = [python,SUMO_tool_path,'randomTrips.py',' -o ',trip_file.per,...
    ' -n ',des_dir,net_file.per,' -e ','3600 ','--weights-output-prefix ','per_weights'];

[status,cmdout] = system(com_generate_trip.bl);
[status,cmdout] = system(com_generate_trip.per);
% change trip file 
weight_file_to_change = ['weights.dst.xml','weights.src.xml','weights.via.xml']
for ii = 1:length(weight_file_to_change)
    fcn_removeEdge(weight_file_to_change(ii));
end



%%
result_file = ['result_',sim_name,'.xml'];
% sumo -c SIM_NAME.sumocfg --fcd-output RESULT.XML
cmd_sim = ['sumo',' -c ', des_dir,sim_name,'.sumocfg',' --fcd-output ',result_file];
% run the simulation
[status,cmdout] = system(cmd_sim)

% convert data: xml -> csv
cmd_file_convert = [python,SUMO_tool_path,'xml\xml2csv.py ',des_dir,result_file]
[status,cmdout] = system(cmd_file_convert)


