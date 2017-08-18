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