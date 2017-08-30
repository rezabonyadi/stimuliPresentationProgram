function runExperiment(expInfo)

experimentInfo=informationPage(expInfo);
fileInfo=saveResults([],experimentInfo);
environment=experimentInfo.environment;
stopFlag=0;

for i=1:length(experimentInfo.runExcelFiles)
    fileInfo.runNumber=i;
    params.operationFile=experimentInfo.runExcelFiles{i};
    params.runNumber=i;
    params.environment=environment;
    firstpageOutputs=readOperationFiles(params);
    tic;
    intermediateResults=cell(1,length(firstpageOutputs.operationsNames)+1);
    intermediateResults{1}=experimentInfo;
    for j=1:length(firstpageOutputs.operationsNames)
        currentOperation=['run' firstpageOutputs.operationsNames{j}];
        operationParameters=firstpageOutputs.operationParams{j};

        operationOutput=...
            feval(currentOperation,operationParameters,environment);
        intermediateResults{j+1}=operationOutput;
        
        if(operationOutput.breakFlag==1)
            % Break the run
            disp('Skipping this run');
            fileInfo=saveResults(fileInfo,'skipped');
            break;
        end;
        if(operationOutput.breakFlag==2)
            % Stop experiment
            disp('Stopping experiment');
            fileInfo=saveResults(fileInfo,'stopped');
            stopFlag=1;
            break;
        end;
        if(strcmpi(operationParameters{6},'S')) % Save this information            
            fileInfo=saveResults(fileInfo,operationOutput);
        end;
        % If ESC then break: TBD
    end;
    
    resName = ['Run' num2str(i)];
    saveAsTable(intermediateResults, resName, fileInfo);
    pause(1); % Ensure the results have been saved.
    if(stopFlag)
        break;
    end;
end;
fclose(fileInfo.file);
sca;