function fcn_xml2csv_multipleFiles(directory,fileRegExpress)
             
folder = fileparts(fileparts(mfilename("fullpath")));
% specify the path to the xml2csv.py script
%xml2csv_script_path = 'D:\Code\tools\xml\xml2csv.py';
xml2csv_script_path = fullfile(folder,'tools\xml\xml2csv.py');
% get a list of all XML files in the directory

files = dir(fullfile(directory, fileRegExpress));
% iterate over all XML files
for i = 1:length(files)
    % construct the full file path
    xml_file_path = fullfile(directory, files(i).name);
    
    % construct the output CSV file path
    [filepath,name,ext] = fileparts(xml_file_path);
    csv_file_path = fullfile(filepath, [name '.csv']);
    
    % call the xml2csv.py script on the XML file
    system(sprintf('python "%s" "%s"', xml2csv_script_path, xml_file_path));
    
    fprintf("%s is generated. \n", csv_file_path);
end
end