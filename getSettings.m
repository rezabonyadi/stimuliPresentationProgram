function environmentSettings = getSettings()
fid=fopen('Settings.txt','rt');
line=fgetl(fid);
i=1;
mySettings=[];
while(ischar(line))
    strs=strsplit(line,'=');
    mySettings{i}=strs{2};
    line=fgetl(fid);
    i=i+1;
end;
fclose(fid);

% subInfo.environmentSettings.name='noShow';
environmentSettings.name=mySettings{1};
keys=strsplit(mySettings{2},' ');
environmentSettings.responseKeys=[];
for i=1:length(keys)
    environmentSettings.responseKeys(i)=double(keys{i});
end;
environmentSettings.screenNumber=str2num(mySettings{3});
disp(['Selected screen is ' num2str(environmentSettings.screenNumber)]);
environmentSettings.fontSize=str2num(mySettings{4});
% subInfo.environmentSettings.shift=str2num(mySettings{5});
environmentSettings.directions=strsplit(mySettings{5},',');
orientations=strsplit(mySettings{6},';');
locFormat = mySettings{7};
environmentSettings.locationStyle=locFormat;

if(locFormat == 'P')
    for i=1:length(orientations)
        num=strsplit(orientations{i},',');
        environmentSettings.directionsRects(i,1)=str2double(num(1));
        environmentSettings.directionsRects(i,2)=str2double(num(2));
    end;
end;
if(locFormat == 'R')
    
    for i=1:length(orientations)
        num=strsplit(orientations{i},',');
        environmentSettings.directionsRects(i,1)=str2double(num(1));
        environmentSettings.directionsRects(i,2)=str2double(num(2));
    end;
end;
