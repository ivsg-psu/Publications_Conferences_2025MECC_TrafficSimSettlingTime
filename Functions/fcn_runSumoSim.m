function fcn_runSumoSim(sim_name, sim_length, add_file_path, varargin)
% This function executes a sumo simulation by calling the sumo -c command
% INPUTS:
% sim_name: the simulation name, string
% sim_length: the simulation length, seconds
% add_file_path: the additional file path to generate the aggregated edge
% based result, XXX.xml
% varargin: Name-Value pairs for optional inputs '--seed', '--output-prefix', and '--fcd-output'

% Revision history:
% 20230419: remove fcd output, since it is not needed.
% 2023xxxx: added '--fcd-output' option

st = dbstack;
fprintf(1,'STARTING function: %s, in file: %s\n', st(1).name, st(1).file);

% Create an input parser object
p = inputParser;

% Define default values
defaultSeed = [];
defaultOutputPrefix = '';
defaultFcdOutput = '';
defaultFcdPeriod = '';

% Add parameters with their default values and map them to valid MATLAB variable names
addParameter(p, 'seed', defaultSeed, @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'outputPrefix', defaultOutputPrefix,@ischar);
addParameter(p, 'fcdOutput', defaultFcdOutput, @ischar);
addParameter(p,'fcdPeriod',defaultFcdPeriod);

% Parse the input arguments
parse(p, varargin{:});

% Retrieve the values
seed = p.Results.seed;
outputPrefix = p.Results.outputPrefix;
fcdOutput = p.Results.fcdOutput;
fcdPeriod = p.Results.fcdPeriod;

% Construct the command
cmd = ['sumo', ' -c ', sim_name, '.sumocfg ', '-e ', sim_length, ' --additional-files ', add_file_path];

% Append optional parameters if provided
if ~isempty(seed)
    cmd = [cmd, ' --seed ', num2str(seed)];
end
if ~isempty(outputPrefix)
    cmd = [cmd, ' --output-prefix ', outputPrefix];
end
if ~isempty(fcdOutput)
    cmd = [cmd, ' --fcd-output ', fcdOutput];
    if ~isempty(fcdPeriod)
        cmd = [cmd,' --device.fcd.period ',num2str(fcdPeriod)]
    end
end



fcn_executeCommand(cmd);

end

