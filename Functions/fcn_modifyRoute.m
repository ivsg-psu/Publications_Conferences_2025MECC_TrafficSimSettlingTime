function fcn_modifyRoute(directory,sim_name)
% This function does the following:
% 1. modify the route file to xx.rou.xml, from the previously set one in
% the template
% 2. correct the element format of net file and route files
files = dir(fullfile(directory, '*.sumocfg'));
for ii = 1:length(files)
filePath = fullfile(directory,files(ii).name);
% Step 1: Read the XML file into a structure
S = readstruct(filePath, 'FileType', 'xml');

% Step 2: Navigate to the node and modify it
% Note: The exact navigation might depend on the structure of your XML.
% This example assumes there is a field 'input' with a subfield 'route_files'.
S.input.route_files.valueAttribute= [sim_name,'.rou.xml'];

% Step 3: Write the modified structure back to an XML file
writestruct(S, filePath, 'FileType', 'xml');

% 读取文件内容
fid = fopen(filePath, 'r');
fileContent = fread(fid, '*char')';
fclose(fid);

% 替换下划线为减号
fileContent = strrep(fileContent, 'net_file', 'net-file');
fileContent = strrep(fileContent, 'route_files', 'route-files');
fileContent = strrep(fileContent, 'struct', 'configuration');
fileContent = strrep(fileContent, 'ignore_route_errors', 'ignore-route-errors');
% 写回修改后的内容到文件
fid = fopen(filePath, 'w');
fwrite(fid, fileContent);
fclose(fid);

end

end