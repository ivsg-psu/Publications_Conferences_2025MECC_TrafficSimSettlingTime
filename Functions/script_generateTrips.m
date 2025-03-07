% Define the traffic volume (in vehicles per second)
trafficVolume = '4'; % veh/sec

% Construct the folder name based on the traffic volume and other parameters
folderName = ['/home/wushuang/Documents/GitHub/ThesisWork/SUMO/TimeIntervalTests/period_',trafficVolume,'vehPsec_','18000sec/'];

% Create a new folder with the constructed name
mkdir(folderName);

% Copy all files from the template folder to the newly created folder
copyfile('/home/wushuang/Documents/GitHub/ThesisWork/SUMO/TimeIntervalTests/template_meanandvar/*',[folderName]);

% Change the current directory to the newly created folder
cd(folderName);

% Define the simulation name
sim_name = 'bl_interval_300m_9x9_twoLane_twoDirection_remove1Lane';

% Define the trip network file name
trip_net_file = 'bl_interval_300m_9x9_twoLane_twoDirection_remove1Lane.net.xml';

% Define the trip flow length (in seconds)
trip_flow_length = '18000';

% Define the period (in seconds)
period = 1/str2num(trafficVolume);
period = num2str(period);

% Generate a random trip file based on the provided parameters
output = fcn_generateRandomTripFile(sim_name,trip_net_file,trip_flow_length,period);

% Define the additional file path
add_filePath = './add60.add.xml';

% Run the SUMO simulation with the specified parameters
fcn_runSumoSim(sim_name,trip_flow_length,add_filePath,'outputPrefix', 'seed_1_interval_60');

% Define the Python script command to fix the aggregated data
temp = 'python /home/wushuang/Documents/GitHub/ThesisWork/Functions/pyscript_fixAggregated_9X9.py ./seed_1_interval_60bl_aggregated60.xml';

% Execute the Python script command
fcn_executeCommand(temp);

% Convert the XML file to a CSV file
fcn_xml2csv('seed_1_interval_60bl_aggregated60.xml');

% run the script to plot cumulative mean and cumulative standard deviation.
run script_MeanAndVar.m; 



