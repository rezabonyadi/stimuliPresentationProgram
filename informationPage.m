function outputs=informationPage(expInfo)
% This will show some text boxes and drop downs to get the subject
% information. 

disp('Information collection page for the experiment');
outputs.function='informationPage';
%% Show the information page
% TBD

%% Prepare the output
outputs.subjectName=[expInfo.subjectName '-' expInfo.session];
allRuns=strsplit(expInfo.runNumbers,',');
outputs.runExcelFiles=cell(1,length(allRuns));
for i=1:length(allRuns)
    outputs.runExcelFiles{i}=['RunsOperationsFiles\Run' allRuns{i} '.csv'];
end;
outputs.subjectAge=expInfo.age;
outputs.subjectGender=expInfo.gender;
outputs.runNumbers=expInfo.runNumbers;
% outputs.runExcelFiles={'RunsOperationsFiles\Run1.csv',...
%     'RunsOperationsFiles\Run3.csv',...
%     'RunsOperationsFiles\Run2.csv'};

outputs.environment=createStimuliEnvironment(expInfo.environmentSettings);

