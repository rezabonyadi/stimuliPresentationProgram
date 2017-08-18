function fileInfo=saveResults(fileInfo,params)
if(isempty(fileInfo))
    % Open a new file and save its info in fileInfo
    fileInfo.fileName=params.subjectName;
    if(exist(['subjectResponses\' params.subjectName]))
        disp('The subject name already exist, postfixing the name randomly.');
        params.subjectName=[params.subjectName '_repeat_' num2str(randi(5000,1))];        
        fileInfo.fileName=params.subjectName;
    end;
    % Create the folder
    mkdir(['subjectResponses\' params.subjectName]);
    fileInfo.file=fopen(['subjectResponses\' params.subjectName '\responses.txt'],'wt');
    fprintf(fileInfo.file,'Subject name: %s\n',params.subjectName);
    fprintf(fileInfo.file,'Subject age: %s\n',params.subjectAge);
    fprintf(fileInfo.file,'Subject gender: %s\n',params.subjectGender);
    fprintf(fileInfo.file,'Subject run files: %s\n',params.runNumbers);
    fprintf(fileInfo.file,'%s','Vaiable response characters map: ');
    for i=1:length(params.environment.viableResponseKeys)
        fprintf(fileInfo.file,'%d= ''%s'',',...
            params.environment.viableResponseKeys(i),...
            char(params.environment.viableResponseKeys(i)));
    end;
    fprintf(fileInfo.file,'\n');
    fprintf(fileInfo.file,'%s\n','---------------');
    return;
end;

if(strcmpi(params,'skipped'))
    skippingTime=toc;
    fprintf(fileInfo.file,'%d;%s;%f\n',fileInfo.runNumber,...
        'The run was skipped at ', skippingTime);
else
    if(strcmpi(params,'stopped'))
        stopTime=toc;
        fprintf(fileInfo.file,'%d;%s;%f\n',fileInfo.runNumber,...
            'The run was stopped at ', stopTime);
    else
        if(isfield(params,'responseTime'))
            fprintf(fileInfo.file,'%d;%s;%s;%f;%f;%d;%s;',fileInfo.runNumber, ...
                params.presentedImage,params.presentedLocation,...
                params.presentationOnset,params.responseTime, params.responseKey);
        else
            fprintf(fileInfo.file,'%d;%s;%s;%f;',fileInfo.runNumber, params.presentedImage,...
                    params.presentedLocation,params.presentationOnset);
        end;
        fprintf(fileInfo.file,'%s\n',params.otherNotes);
    end;

end;