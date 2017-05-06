function presentationInfo=showImage(showInfo,operation)
% This function will show an image at the provided
% location. It underestands 'Cross' and loads the cross image
% automatically. The image path must be also provided.
environment=showInfo.environment;

% Present the figure
disp(['Presenting ' showInfo.imagePath ' ' showInfo.imageName ' at ' ... 
    num2str(showInfo.imageLoc) ' inside the object ' environment.name]);

KbEventFlush(0); % Empty keyboard buffer
% disp(rem);

showMyImage(showInfo);

presentationInfo.presentationOnset=toc;
presentationInfo.presentedImage=showInfo.imageName;
presentationInfo.presentedLocation=showInfo.imageLoc;

if(~isempty(operation))
    if(strcmpi(operation.function,'waitForKey'))
        if(~isempty(operation.keyToWaitFor))
            % A code that waits for while the stimili environment in on
            % top. It waits for the correct key to come.   
            [~,~,presentationInfo.breakFlag]=...
                waitAndRegisterFirstKey(inf,operation.keyToWaitFor,...
                [environment.escapeKey(1),environment.escapeKey(2)],...
                [environment.pauseKey(1),environment.pauseKey(2)],...
                [environment.stopKey(1),environment.stopKey(2)]);
        else % Any key
            % A code that waits for while the stimili environment in on
            % top. It waits for any key to come.
            [~,~,presentationInfo.breakFlag]=...
                waitAndRegisterFirstKey(inf,[],...
                [environment.escapeKey(1),environment.escapeKey(2)],...
                [environment.pauseKey(1),environment.pauseKey(2)],...
                [environment.stopKey(1),environment.stopKey(2)]);
        end;
    end;
    if(strcmpi(operation.function,'keyAndTime'))
        % A code that shows the stimuli for a given time and registers the 
        % keys hit during that time. 
        [presentationInfo.responseTime,presentationInfo.responseKey,...
            presentationInfo.breakFlag]=waitAndRegisterFirstKey(operation.timeToPause...
            ,environment.viableResponseKeys,...
            [environment.escapeKey(1),environment.escapeKey(2)],...
            [environment.pauseKey(1),environment.pauseKey(2)],...
            [environment.stopKey(1),environment.stopKey(2)]);
    end;
    if(strcmpi(operation.function,'givenTime'))  
        % A code that shows the stimuli for a given time.        
        [~,~,presentationInfo.breakFlag]=...
            waitAndRegisterFirstKey(operation.timeToPause,[],...
            [environment.escapeKey(1),environment.escapeKey(2)],...
            [environment.pauseKey(1),environment.pauseKey(2)],...
            [environment.stopKey(1),environment.stopKey(2)]);
    end;
end;

function showMyImage(showInfo)
environment=showInfo.environment;
if(strcmpi(environment.name,'psychToolbox')) 
    % Use psychtoolbox for presentation. Alternatives could be also
    % implemented.
    if(strfind(lower(showInfo.imagePath),'justtext'))
        x=strsplit(lower(showInfo.imagePath),'-');
%         [s1,s2,~]=size(theImage);
        if(strcmp(showInfo.imageLoc,'screen'))
            dstRects=[];
        else
            baseRect = [0 0 100 100];
            location=strncmp(showInfo.imageLoc,environment.directions,2);
            convLocation=environment.directionsRects(location,:); 
            dstRects=CenterRectOnPointd(baseRect, convLocation(1), convLocation(2));
        end;
%         [left top right bottom];
        if(length(x)>1)
            Screen('TextSize', environment.window, str2double(x(2)));
        else
            % Standard font size
            Screen('TextSize', environment.window, environment.fontSize);
        end;
        DrawFormattedText(environment.window, showInfo.imageName, 'center', 'center',...
            showInfo.environment.white,[],[],[],[],[],dstRects);
    else
        theImageAddress=[showInfo.imagePath showInfo.imageName];
        theImage = imread(theImageAddress);
        [s1,s2,~]=size(theImage);
        baseRect = [0 0 s1 s2];
        location=strncmp(showInfo.imageLoc,environment.directions,2);
        convLocation=environment.directionsRects(location,:); 
        dstRects=CenterRectOnPointd(baseRect, convLocation(1), convLocation(2));
%         disp(baseRect);
%         disp(dstRects);
        % A code that shows the stimuli within the environment
        imageTexture = Screen('MakeTexture', environment.window, theImage);
        Screen('DrawTexture', environment.window, imageTexture, [], dstRects, 0);
    end;
    Screen('Flip', environment.window);
end;

function [responseTime,responseKey,breakFlag]=...
    waitAndRegisterFirstKey(timeToPause,charToReg,charToBreak,charToPause,charToStop)
breakFlag=0;
responseKey=-1;
responseTime=-1;
breakRepeat=0;
pauseRepeat=0;
stopRepeat=0;
if(isinf(timeToPause))
    while isempty(find(responseKey == charToReg, 1)) 
        % If the pressed key was in the given set of keys
        [~,k,se]=KbStrokeWait(0);
        responseKey=find(k);
        disp(['Key ' KbName(k) ' was hit while waiting for ' char(charToReg)]);
        wasBreak=checkForBreak(responseKey,charToBreak(1),charToPause(1),charToStop(1));
        breakRepeat=breakRepeat+wasBreak;            
%         disp(KbName(responseKey));
        if(breakRepeat>=charToBreak(2))
            breakFlag=1;
            break;
        end;
        if(stopRepeat>=charToBreak(2))
            breakFlag=2; % Stop experiment
            break;
        end;
    end;
else
    startTime=GetSecs;
    endTime=timeToPause+startTime;
    responseKey=-1;
    currTime=GetSecs;
    responseTime=-1;
    while currTime<endTime
        [~,~,k,~]=KbCheck;
        key=find(k);
%         disp(key);
        if(~isempty(key))               
            key=key(1); % To ensure, if two keys pressed together, one of them is registerred.            
            % A key has been pressed, and it was the first key that was pressed
            if(responseKey==-1 && ~isempty(find(key==charToReg)==1)) 
                % If a key was not pressed before and the key was one the
                % ones we consider for response.
                disp(['Key ' KbName(k) ' was hit']);
                responseKey=key;
                responseTime=currTime-startTime;
            end;
            [wasBreak,wasPause,wasStop]=checkForBreak(key,charToBreak(1),charToPause(1),charToStop(1));
            breakRepeat=breakRepeat+wasBreak;            
            pauseRepeat=pauseRepeat+wasPause;            
            stopRepeat=stopRepeat+wasStop;                        
            
            if(breakRepeat>=charToBreak(2))
                breakFlag=1; % Skip this run
                break;
            end;
            if(stopRepeat>=charToBreak(2))
                breakFlag=2; % Stop experiment
                break;
            end;
        end;
        WaitSecs(0.001);
        currTime=GetSecs;
    end;
end;

function [breakPressed,pausePressed,stopPressed]=...
    checkForBreak(responseKey,charToBreak,charToPause,charToStop)
breakPressed=0;
stopPressed=0;
pausePressed=0;

if(responseKey==charToBreak)    
    breakPressed=1;
end;
if(responseKey==charToPause)    
    pausePressed=1;
end;
if(responseKey==charToStop)    
    stopPressed=1;
end;