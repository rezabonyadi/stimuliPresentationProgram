function saveAsTable(intermediateResults, resName, fileInfo)
save(['subjectResponses\' fileInfo.fileName '\' resName '.mat']...
        ,'intermediateResults'); % Saves the results of each run as a mat file.
    
fieldNames={'presentationOnset','presentedImage', 'presentedLocation', ...
    'responseTime', 'responseKey', 'breakFlag', 'otherNotes'};
allRows={};
resRows={};
k=1;
for i=2:length(intermediateResults)
    for j=1:length(fieldNames)        
        if(isfield(intermediateResults{i},fieldNames{j}))
            allRows{i-1,j}=intermediateResults{i}.(fieldNames{j});
        else
            allRows{i-1,j}=[];
        end;        
    end;
    if(isfield(intermediateResults{i},'responseKey'))%Only responses rows
        resRows(k,:)=allRows(i-1,:);
        k=k+1;
    end;
end;
myTableAll=cell2table(allRows,'VariableNames',fieldNames);
myTableRes=cell2table(resRows,'VariableNames',fieldNames);
writetable(myTableAll, ...
    ['subjectResponses\' fileInfo.fileName '\' resName '_all_table.csv']);
writetable(myTableRes, ...
    ['subjectResponses\' fileInfo.fileName '\' resName '_res_table.csv']);

