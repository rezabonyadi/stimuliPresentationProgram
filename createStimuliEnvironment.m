function environment=createStimuliEnvironment(environmentSettings)
% environment=figure;
% environment.name='psychToolbox';
environment.name=environmentSettings.name;%'noShow';
environment.viableResponseKeys=environmentSettings.responseKeys;
environment.escapeKey=[27,300]; % ASCII of esc
environment.pauseKey=[-1,300]; % ASCII of space
environment.stopKey=[79,300]; % ASCII of space
environment.viableOperations={'waitForKey','keyAndTime','givenTime'};
environment.fontSize=environmentSettings.fontSize;

if(strcmpi(environment.name,'psychToolbox'))
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    % See http://docs.psychtoolbox.org/Preference    
    Screen('Preference', 'DefaultFontSize', environmentSettings.fontSize);
    fontStyle= Screen('Preference', 'DefaultFontStyle',1);
    Screen('Preference', 'SkipSyncTests', 1);

    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen.
    environment.screenNumber = environmentSettings.screenNumber;

    % Define black and white (white will be 1 and black 0). This is because
    % in general luminace values are defined between 0 and 1 with 255 steps in
    % between. All values in Psychtoolbox are defined between 0 and 1
    environment.white = WhiteIndex(environment.screenNumber);
    environment.black = BlackIndex(environment.screenNumber);

    % Do a simply calculation to calculate the luminance value for grey. This
    % will be half the luminace values for white
    environment.bkColor = environment.white / 2;

    % Open an on screen window using PsychImaging and color it grey.
    environment.window=0;
    environment.windowRect=0;
    sca;
    [environment.window, environment.windowRect] = PsychImaging('OpenWindow', ...
        environment.screenNumber, environment.bkColor);
    
    environment.directions=environmentSettings.directions;
    environment.directionsRects=environmentSettings.directionsRects;
    
%     environment.directions={'MT','RT','RM','RB','MB','LB','LM','LT','MM'};
%     environment.directionsRects=zeros(9,2);
%     shiftScreen=environmentSettings.shift;
%     
%     for i=1:9
%         d=environment.directions{i};
%         rec=environment.windowRect(3:4);
%         if(d(1)=='M')
%             rec(1)=rec(1)*0.5;
%         end;
%         if(d(1)=='R')
%             rec(1)=rec(1)*(5-shiftScreen)/6;
%         end;
%         if(d(1)=='L')
%             rec(1)=rec(1)*(1+shiftScreen)/6;
%         end;
%         if(d(2)=='M')
%             rec(2)=rec(2)*0.5;
%         end;
%         if(d(2)=='B')
%             rec(2)=rec(2)*(5-shiftScreen)/6;
%         end;
%         if(d(2)=='T')
%             rec(2)=rec(2)*(1+shiftScreen)/6;
%         end;
%         environment.directionsRects(i,:)=rec;
%     end;
end;
