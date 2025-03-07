function fcn_xml2csv(xmlFilePath)
% This function calls a python script built-in in SUMO, xml2csv.py, to
% convert a file from xml to csv.
% Input:
% xmlFilePath: the path to the xml file you want to convert to csv, in
% string

% Created on: 2023 03 29
% Author: Wushuang Bai

cmd = ['python D:\Code\tools\xml\xml2csv.py ',xmlFilePath];
fcn_executeCommand(cmd);

end