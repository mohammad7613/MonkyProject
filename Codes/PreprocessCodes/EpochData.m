clc;
clear;
close all;
% Load CleanData
version = 2;
file_name_set = ['presessionData_v',num2str(version),'.set'];
path = pwd;
EEG = pop_loadset(file_name_set,path);

file_name_session = 'sessionData.mat';
file_path = [path,'\',file_name_session];
load(file_path);

%assert(size(EEG.data,1) == size(channelData',1)); apply downsample!
%assert(size(EEG.data,2) == size(channelData',2));

normalizedData = normalize(EEG.data,2);

assert(all(size(EEG.data) == size(normalizedData)))

if EEG.srate == 1000
    digitalByte = digitalByte(1:2:end);
    disp('Downsample');
end
    
events = [10,20];
names = {'Target','Standard'};
onsetTimes = find(ismember(digitalByte,events));
tag = onsetTimes (diff ([0 onsetTimes']) > 1);

preOnsetDuration = 0.2; % in seconds

postOnsetDurtion = 1;
preOnsetSamplesNum = ceil(preOnsetDuration*EEG.srate); 
postOnsetSamplesNum = ceil(postOnsetDurtion*EEG.srate); 
EpochedData = zeros(size(EEG.data, 1),length(tag),preOnsetSamplesNum + postOnsetSamplesNum + 1);

for iTrial = 1:size(EpochedData, 2)
    os = tag(iTrial) ;
    EpochedData(:,iTrial,:) = normalizedData(:, os-preOnsetSamplesNum:os+postOnsetSamplesNum);
end

for i=1:size(events,2)
    onsetTimes = find(ismember(digitalByte,events(i)));
    tag_temp = onsetTimes (diff ([0 onsetTimes']) > 1);
    a = repmat(tag_temp',size(tag,1),1);
    b = repmat(tag,1,size(tag_temp,1));
    r = sum(a==b,2);
    Epoch.events(i).trigger_index = find(r);
    Epoch.events(i).name = names{i};
end
Epoch.data = EpochedData;
file_name_epochs = 'normalizedLFPOverTime_EpochedData.mat';
file_name_epchs_merged = [file_name_set(1:end-4),'_',file_name_epochs];
save([path,'\',file_name_epchs_merged],'Epoch');

