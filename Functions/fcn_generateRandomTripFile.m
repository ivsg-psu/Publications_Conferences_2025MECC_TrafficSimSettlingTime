function cmd = fcn_generateRandomTripFile(sim_name,trip_net_file, trip_flow_length,period,varargin)
% This function calls SUMO randomTrip.py to generate random trip file.

toolspath = fullfile(fileparts(fileparts(mfilename("fullpath"))),'tools')
randomTripPath = fullfile(toolspath,'randomTrips.py')

%     ' -n ',trip_net_file,' -e ',trip_flow_length,' --period ',period];
% fcn_executeCommand(cmd);
% outputFileName = [sim_name,'.trips.xml'];
st = dbstack;
fprintf(1,'STARTING function: %s, in file: %s\n', st(1).name, st(1).file);

% Create an input parser object
p = inputParser;

% Define default values
defaultWeightsOutputPrefix = '';
defaultRouteFile = '';

% Add parameters with their default values and map them to valid MATLAB variable names
addParameter(p, 'weightsOutputPrefix', defaultWeightsOutputPrefix,@ischar);
addParameter(p, 'routeFile', defaultRouteFile,@ischar);


% Parse the input arguments
parse(p, varargin{:});


weightsOutputPrefix = p.Results.weightsOutputPrefix ;
routeFile = p.Results.routeFile;
% Construct the command
cmd = ['python ',randomTripPath,' -o ',sim_name,'.trips.xml'...
     ' -n ',trip_net_file,' -e ',trip_flow_length,' --period ',period,' --fringe-factor 10 '];

% Append optional parameters if provided
if ~isempty(weightsOutputPrefix)
    cmd = [cmd, ' --weights-output-prefix ', weightsOutputPrefix];
end

if ~isempty(routeFile)
    cmd = [cmd, ' -r ', routeFile];
end

fcn_executeCommand(cmd);
end