% This function takes an xml file as input (usually edge data in SUMO),
% changes the probability value of given edges to 0. 


function fcn_removeEdge(xmlFileName,edgeToChange)
st = dbstack; %#ok<*UNRCH>
fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
readInxml = readstruct(xmlFileName);
for ii = 1:length(readInxml.interval.edge)
    if ismember(readInxml.interval.edge(ii).idAttribute,edgeToChange)
        readInxml.interval.edge(ii).valueAttribute = 0;
    end    
end

%outputXml = readInxml;
writestruct(readInxml,['removedEdge_',xmlFileName]);
end

