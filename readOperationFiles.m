function firstpageOutputs=readOperationFiles(params)
%% Read the operation file for the current run
fid=fopen(params.operationFile,'rt');
currentLine=fgetl(fid);
i=1;
while ischar(currentLine)
    operationsTable=strsplit(currentLine,',');
    operationsTable=operationsTable(~cellfun('isempty',operationsTable));
    if(isempty(operationsTable)) % The line did not include any opearion
        currentLine=fgetl(fid);
        continue;
    end;
    operationViability=strncmpi(operationsTable{1},...
        params.environment.viableOperations,length(operationsTable{1}));
    if(isempty(operationViability)) % The operation in this line was not listed as viable operations.
        disp(['The opration ' operationsTable{1} ' is not viable.']);
        currentLine=fgetl(fid);
        continue;
    end;
    
    firstpageOutputs.operationsNames{i}=operationsTable{1};
    % The information of where to show this stimuli is in this object     
    firstpageOutputs.operationParams{i}=operationsTable(2:end);
    currentLine=fgetl(fid);
    i=i+1;
end;
fclose(fid);
