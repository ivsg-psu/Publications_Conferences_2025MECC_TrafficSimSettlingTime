% This is the main script to run region of influence analysis for SUMO
% simulations. This script does the following things:
% 1. call script_runSumoSim to run sumo simulation 
% 2. call script_calcEffectiveROI_SUMO to calculate the ROSI, or region of
% significant influence 
% Author: Wushuang Bai
% Created on: 2022 12 04 
% INPUTS:
% 1. flag.runSumoSim: if set to 1, it calls script_runSumoSim to run sumo
% simulation. If simulation results are already done, this flag can be set to 0 
% 2. flag.calcEffectiveROI: if set to 1. it calls
% script_calcEffectiveROI_SUMO to do data analysis using the simulation
% results
% 3. flag.simNumber: this specifies which simulation you want to run 
% 3. sim_name: the simulation name. This decides which simulation you want
% to run
% 4. per_coor: the coordinate of perturbation in the road network. Usually
% it is the center of the network. 
% 5. edges to remove: these are the removed edges due to removing nodes on
% the network, as perturbation 
% 6. sim_time_length: this is the time length of the SUMO simulation. This
% is used to cut off simulation results to make sure that baseline and
% perturbed results have the same time length. 

%% Prepare for work space
clc; close all; 
tic;
addpath(genpath("/home/wushuang/Documents/GitHub/ThesisWork/"));
addpath(genpath("/home/wushuang/Documents/GitHub/Region_of_influence/Functions/"));
addpath(genpath("/home/wushuang/Documents/GitHub/Region_of_influence/MainScripts/"));
cd /home/wushuang/Documents/GitHub/ThesisWork/Functions;

%% User flag inputs
flag.runSumoSim = 1;               % 1: run the sim 
flag.calcEffectiveROI_SUMO = 1;    % 1: run the script
flag.calcMFD = 1;                  % 1: run the script

flag.simNumber = 10;                % which simulation you want to run?
%flag.period = '1';                   % set the arrival rate to be 1/period. Default = 1; 
                                    % options: 1,0.5,0.2;
trip_time_length = '1200';  % simulation time length
speeddev = '0.1';          % speed deviation. let it be 0.1 for code traffic. 

timeStep = 100; % input time granularity
RadiusStep = 100; % input radius granularity
manhattanDisStep = 50; % input manhattan distance granularity 

% For MFD
edgeLength = 300; % The length of one edge, meters
interval = 60; % The measurement interval for MFD estimation, sec. 

%% Run main script as branches
% all baseline edge file is the same one. 
% bl_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/','11x11_oneLane_twoDirection_remove1node',...
%     '/','edgecomp/','bl_','11x11_oneLane_twoDirection_remove1node','.edg.xml');

bl_edge_path = ['/home/wushuang/Documents/GitHub/ThesisWork/SUMO/bl_300m_21x21_oneLane_twoDirection_remove1node.edg.xml'];
fprintf('Using the following path for the baseline edges: %S\n', bl_edge_path);

if flag.simNumber == 1
sim_name = '11x11_oneLane_twoDirection_remove1node';
per_coor = [2500,2500]; % This is the coordinate of the center of the removed node(s);

per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
%edges_to_remove = ["F5E5","E5F5","F6F5","F5F6","G5F5","F5G5","F4F5","F5F4"]; % This is the removed edges due to removed nodes.
edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
queryDisStart = 750;
% elseif flag.simNumber ==2
% sim_name = '11x11_oneLane_twoDirection_remove4node';
% per_coor = [2250,2750]; % This is the coordinate of the center of the removed node(s);
% %bl_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','bl_',sim_name,'.edg.xml');
% per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
% edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
% queryDisStart = 1000; % min distance: 750
% 
% elseif flag.simNumber ==3
% sim_name = '11x11_oneLane_twoDirection_remove9node';
% per_coor = [2500,2500]; % This is the coordinate of the center of the removed node(s);
% 
% per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
% edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
% queryDisStart = 1250; % min distance: 1000
% 
% elseif flag.simNumber ==4
% sim_name = '11x11_oneLane_twoDirection_remove16node';
% per_coor = [2250,2250]; % This is the coordinate of the center of the removed node(s);
% 
% per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
% edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
% queryDisStart = 1500;  % min distance: 1250 
% elseif flag.simNumber ==5
% sim_name = '11x11_oneLane_twoDirection_remove25node';
% per_coor = [2500,2500]; % This is the coordinate of the center of the removed node(s);
% 
% per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
% edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
% queryDisStart = 1750;  % min distance: 1500 
% 
% elseif flag.simNumber ==6
% sim_name = '11x11_oneLane_twoDirection_remove81node';
% per_coor = [2500,2500]; % This is the coordinate of the center of the removed node(s);
% 
% per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
% edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
% queryDisStart = 2750;  % min distance: 1500 
% 
% % using the same baseline edge file as 500 meters, since the edges ID are the same.
% % The difference is the lengths of the edges, which are NOT reflected in
% % the edge.xml. 
% elseif flag.simNumber == 7 
% 
% sim_name = '100m_11x11_oneLane_twoDirection_remove1node';
% per_coor = [500,500]; % This is the coordinate of the center of the removed node(s);
% 
% per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
% edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
% queryDisStart = 200;  % min distance: 1500 

elseif flag.simNumber == 8

sim_name = '300m_21x21_oneLane_twoDirection_remove1node';
per_coor = [3000,3000]; % This is the coordinate of the center of the removed node(s);

per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
queryTimeStart = 600;
queryDisStart = 500;  % min distance: 500: missing shortest edge length + 200 

elseif flag.simNumber == 9

sim_name = '300m_21x21_oneLane_twoDirection_remove9node';
per_coor = [3000,3000]; % This is the coordinate of the center of the removed node(s);

per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
queryTimeStart = 600;
queryDisStart = 800;  % min distance: 600 + 200

elseif flag.simNumber == 10
sim_name = '300m_21x21_oneLane_twoDirection_remove25node';
per_coor = [3000,3000]; % This is the coordinate of the center of the removed node(s);

per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
queryTimeStart = 600;
queryDisStart =1100;  % min distance: 900+200





elseif flag.simNumber == 12

sim_name = '300m_21x21_oneLane_twoDirection_remove81node';
per_coor = [3000,3000]; % This is the coordinate of the center of the removed node(s);

per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
queryTimeStart = 600;
queryDisStart = 1550;  % min distance: 1500 

elseif flag.simNumber == 13

sim_name = '300m_21x21_oneLane_twoDirection_remove169node';
per_coor = [3000,3000]; % This is the coordinate of the center of the removed node(s);

per_edge_path = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','edgecomp/','per_',sim_name,'.edg.xml');
edges_to_remove = fcn_compareEdgeDiff(bl_edge_path,per_edge_path);
queryTimeStart = 600;
queryDisStart = 2200;  % min distance: 2000 




end

% Create a directory to store images
figPath = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','Fig');
mkdir(figPath);
addpath(genpath(figPath));
executionPath = strcat('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/',sim_name,'/','period_',flag.period,'sec/');
mkdir(executionPath);
addpath(genpath(figPath));
cd(executionPath);

if 1 == flag.runSumoSim
    run script_runSumoSim.m;
end

disp('===================================================');

if exist('prefix','var') ~= 1
prefix = {'bl','per'};

end
if 1 == flag.calcEffectiveROI_SUMO
    run script_calcEffectiveROI_SUMO.m; 
end
if 1 == flag.calcMFD
    run script_calcMFD.m;
end




toc;


