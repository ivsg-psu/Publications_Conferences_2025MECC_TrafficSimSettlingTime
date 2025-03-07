% This script does the following things: 
% 1. generate road trip file xx.rou.xml and the relevant source filfe
% xx.src.xml, destination file xx.dst.xml and mid way points file
% xx.via.xml
% 2. remove the given edges from the source file, destination file.
% For files of perturbed simulation, also remove edges from the mid way
% points file
% 3. generate simulation configuration file xx.sumocfg
% 4. run the simulations 
% 5. convert simulat results from xml to csv

% Author: Wushuang Bai
% Created on: 2022 11 27

% TODO LIST:
% 1. for baseline, do not touch xx.via.xml -- done
% 2. test this script -- done
% 3. add if statements for different simulation scenarios. -- done

% Revision history:
% 20230301: add code to add additional xml file into the sumocfg file for MFD calculation
% 20230313: change trip_time_length to trip_flow_length, add
% trip_sim_length to force the end of simulation
% 20230329: add code to convert edge xml to csv, for plotting purpose



%% user's inputs

% check OS

SUMO_tool_path = '/media/wushuang/SeagateMac/Code/tools/';
sim_dir = executionPath;
python = 'python ';
function_dir = '/home/wushuang/Documents/GitHub/ThesisWork/Functions/';
template_dir = '/home/wushuang/Documents/GitHub/ThesisWork/SUMO/Template/';





%% Generate road trip file:
% 1. src,dst,via files
% 2. trip files

prefix = {'bl','per'};

for ii = 1:2
% define files to use
% net file
net_file.(prefix{ii}) = strcat(prefix{ii},'_',sim_name,'.net.xml');
% trip file 
trip_file.(prefix{ii}) = strcat((prefix{ii}),'_',sim_name,'.trips.xml');
% command to produce src,dst,via files
com_generate_trip.(prefix{ii}) = [python,SUMO_tool_path,'randomTrips.py',...
    ' -n ',sim_dir,net_file.(prefix{ii}),' -e ',trip_flow_length,' --period ',flag.period,' --weights-output-prefix ',prefix{ii},'_weights'];

% execute commmand to generate trip and produce src,dst,via files
fcn_execudeCommand(com_generate_trip.(prefix{ii}));
fprintf("Initial trip, src, dst and via files generated! \n");
% change trip file 
weight_file_to_change.(prefix{ii}) = {[prefix{ii},'_weights.dst.xml'],[prefix{ii},'_weights.src.xml']};

for jj = 1:2
    fcn_removeEdge(weight_file_to_change.(prefix{ii}){jj},edges_to_remove);
end

%% Remove given edges
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%NOTE: for baseline, don't change the xx.via.xml file, since we need the
%perturbation nodes serve as middle way points. 
%for perturbed, remove these nodes from xx.via.xml, since these nodes are just
%removed from the map
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if strcmp(prefix{ii},'bl')
    writestruct(readstruct('bl_weights.via.xml'),'removedEdge_bl_weights.via.xml');
elseif strcmp(prefix{ii},'per')
    fcn_removeEdge('per_weights.via.xml',edges_to_remove);
end
fprintf("New src, dst and via files generated with specified edges removed! \n");

% command to produce new trip files using updated src,dst and via files
com_update_trip.(prefix{ii}) = [python,SUMO_tool_path,'randomTrips.py',' -o ',prefix{ii},'_',sim_name,'.trips.xml'...
    ' -n ',sim_dir,net_file.(prefix{ii}),' -e ',trip_flow_length,' --period ',flag.period,' --weights-prefix ','removedEdge_',prefix{ii},'_weights'];

fcn_execudeCommand(com_update_trip.(prefix{ii}));
fprintf("New trip file generated with specified edges removed! \n");

%% Generate simulation configuration file
%Generate simulation file xx.sumocfg, using template.sumocfg, and call a
%python script
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
com_generate_sumocfg.(prefix{ii}) =  [python, function_dir,'script_writeSumocfg.py ', sim_dir,prefix{ii},'_',sim_name];
fcn_execudeCommand(com_generate_sumocfg.(prefix{ii}));
sumocfgFilePath = [sim_dir,prefix{ii},'_',sim_name,'.sumocfg '];
com_copyAddXML = ['cp ',template_dir,'template_',prefix{ii},'.add.xml ',executionPath];
fcn_execudeCommand(com_copyAddXML);
com_writeMFDXML.(prefix{ii}) = [python, function_dir,'script_writeMFDXML.py ', sumocfgFilePath,' ',prefix{ii}];
fcn_execudeCommand(com_writeMFDXML.(prefix{ii}));
fprintf("SUMO configuration files generated! \n");

%% Run simulations% 
% The following files are needed:
% 1. simulation file: xx.sumocfg
% 2. route file: xx.trips.xml
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
result_file.(prefix{ii}).xml = [prefix{ii},'_result_',sim_name,'.xml'];
% sumo -c SIM_NAME.sumocfg --fcd-output RESULT.XML
com_sim.(prefix{ii}) = ['sumo',' -c ', sim_dir,prefix{ii},'_',sim_name,'.sumocfg ','-e ',trip_sim_length,' --default.speeddev ',speeddev,' --fcd-output ',result_file.(prefix{ii}).xml];
% run the simulation
fcn_execudeCommand(com_sim.(prefix{ii}));
fprintf("SUMO simulation is done! \n");

%% convert simulation results: xml -> csv 
cmd_file_convert.(prefix{ii})  = [python,SUMO_tool_path,'xml/xml2csv.py ',sim_dir,result_file.(prefix{ii}).xml];
fcn_execudeCommand(cmd_file_convert.(prefix{ii}));
fprintf("Simulation results has been converted to csv format! \n");


%% convert edge-based results: xml -> csv

cmd_MFD_convert.(prefix{ii})  = [python,SUMO_tool_path,'xml/xml2csv.py ',sim_dir,prefix{ii},'_aggregated.xml'];
fcn_execudeCommand(cmd_MFD_convert.(prefix{ii}) )

disp('===================================================');

%% convert edge file and node file: xml -> csv
edgecompPath = ['/home/wushuang/Documents/GitHub/ThesisWork/SUMO/9x9network/',sim_name,'/edgecomp/'];
edgexmlPath = strcat(edgecompPath,'per_',sim_name,'.edg.xml');
nodexmlPath = strcat(edgecompPath,'per_',sim_name,'.nod.xml');
fcn_xml2csv(edgexmlPath);
fcn_xml2csv(nodexmlPath);


end

