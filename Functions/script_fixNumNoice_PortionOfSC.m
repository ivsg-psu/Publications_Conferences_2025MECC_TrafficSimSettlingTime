edgeList1 = {'-261167033#2','261167033#0','261178220#5','-261178220#5','11832888#0','-11832888#0',...
    '-11839944#8','507804536#3','-507804536#3','11839944#7','11836287#4','-11836287#4',...
    '-11846708#8','11846708#5'}
edgeList2 = {'-11842756#7'};

for ii = 1:length(tTestResult)
    if ismember(tTestResult{ii}.edgeID{1},edgeList1)

        tTestResult{ii}.h = 0;
    end
    if ismember(tTestResult{ii}.edgeID{1},edgeList2)

        tTestResult{ii}.h = 1;
    end
end