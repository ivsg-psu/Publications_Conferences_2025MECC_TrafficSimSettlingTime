function fcn_executeCommand(command)
st = dbstack; %#ok<*UNRCH>
fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
[status,cmdout] = system(command);
if status ~= 0
    error(cmdout);
end

end
