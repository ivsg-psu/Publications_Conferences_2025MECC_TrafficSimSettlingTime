function fcn_xml2csv_fixXML(directory,fileRegExpress,sim_name)          
if strcmp(sim_name,'PortionOfSC')
pyscriptName = '/home/wushuang/Documents/GitHub/ThesisWork/Functions/pyscript_fixAggregated_SC.py';
pyscriptName = fullfile()
elseif strcmp(sim_name,'300m_9x9_twoLane_twoDirection_remove1Lane')
pyscriptName = '/home/wushuang/Documents/GitHub/ThesisWork/Functions/pyscript_fixAggregated_9X9.py'; 
pyscriptName = 
end
% files = dir(fullfile(directory, fileRegExpress));
% % iterate over all XML files
% for i = 1:length(files)
%     % construct the full file path
%     xml_file_path = fullfile(directory, files(i).name);
%     fcn_executeCommand(['python ',pyscriptName,' ',xml_file_path]);     
% 
% end
end