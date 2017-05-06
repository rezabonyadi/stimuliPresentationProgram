function output=runImageShow(params,environment)
showInfo.imagePath=params{3};
showInfo.imageName=params{4};
showInfo.imageLoc=params{5};
showInfo.environment=environment;

operation.function=params{1};
if(strcmpi(operation.function,'waitForKey'))
    operation.keyToWaitFor=double(params{2}); % '5' or ESC
end;
if(strcmpi(operation.function,'givenTime'))
    operation.timeToPause=str2double(params{2});
end;
if(strcmpi(operation.function,'keyAndTime'))
    operation.timeToPause=str2double(params{2});
end;

output=showImage(showInfo,operation);
output.otherNotes='';
if(length(params)>6) % there are extra notes to be saved   
    if(strcmp(params{7},'*')) % This is the start of the scanner
        tic;
    else
        output.otherNotes=strjoin(params(7:end),';');
    end;
end;