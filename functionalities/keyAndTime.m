function presentationInfo=keyAndTime(operation,environment,presentationInfo)
breakFlag=0;
responseKey=-1;
responseTime=-1;
breakRepeat=0;
pauseRepeat=0;
stopRepeat=0;

timeToPause=operation.timeToPause;
charToReg=environment.viableResponseKeys;
charToBreak=[environment.escapeKey(1),environment.escapeKey(2)];
charToPause=[environment.pauseKey(1),environment.pauseKey(2)];
charToStop=[environment.stopKey(1),environment.stopKey(2)];


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
presentationInfo.breakFlag=breakFlag;
presentationInfo.responseTime=responseTime;
presentationInfo.responseKey=responseKey;