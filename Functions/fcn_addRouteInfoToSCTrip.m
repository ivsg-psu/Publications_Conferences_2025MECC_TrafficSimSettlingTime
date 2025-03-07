function fcn_addRouteInfoToSCTrip(tripFilePath)
% This function add route information into the trip xml file of state
% college.
% INPUTS:
% tripFilePath: the path to the state college trip file
st = dbstack; %#ok<*UNRCH>
fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
cmd = "python script_addRouteInfoToSCTrip.py " + tripFilePath;
fcn_execudeCommand(cmd); 

end