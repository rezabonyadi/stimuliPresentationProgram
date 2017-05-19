function presentationInfo=waitForKey(operation,environment,presentationInfo)
breakFlag=0;
responseKey=-1;
responseTime=-1;
breakRepeat=0;
pauseRepeat=0;
stopRepeat=0;
% timeToPause=operation.keyToWaitFor;
charToReg=operation.keyToWaitFor;
charToBreak=[environment.escapeKey(1),environment.escapeKey(2)];
charToPause=[environment.pauseKey(1),environment.pauseKey(2)];
charToStop=[environment.stopKey(1),environment.stopKey(2)];

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
presentationInfo.breakFlag=breakFlag;