% This script runs baseline and perturbed simulation for artificial
% network, and state college

% Baseline: just let the simulation run
% Perturbed: set a vehicle parking in a lane

% Author: Wushuang Bai
% Revision history:
% 20230407 first write of code

%% definition of useful paths

SUMO_tool_path = '/media/wushuang/SeagateMac/Code/tools/';
python = 'python3 ';
function_dir = '/home/wushuang/Documents/GitHub/ThesisWork/Functions/';
template_dir = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/Template/';
addpath(genpath(function_dir));
%% user inputs
clc;close all; 
sim_name = 'PortionOfSC';
sim_dir = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/StateCollege/PortionOfSC/'
flag.period = '1';   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flow_length = '950';            % how long do you want to insert vehicles into the network?
                                % 900 sec. Add 50s for buffer. 
sim_length = '1200';            % how long do you want to force your simulation to end? Adding 300 sec to trip_flow_length for buffer
speeddev = '0.1';               % speed deviation. let it be 0.1 for code traffic. 

%% create directories
folderName = ['period_',flag.period,'sec'];
mkdir(folderName);

%%
net_file = [sim_name,'.net.xml'];
net_file = [sim_dir,net_file];


%% generate random trips 
tripFile = fcn_generateRandomTripFile(sim_name,net_file,flow_length,flag.period);

%% add route information to the generated trip file
fcn_addRouteInfoToSCTrip(tripFile);

%% run simulation







