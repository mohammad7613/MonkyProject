clc;
clear;
close all;

mat_files_event = dir(fullfile(pwd,'**/triggers.mat'));
mat_files_data = dir(fullfile(pwd,'**/CleanData/CleanData.mat'));


for ifolder = 1:length(mat_files_data)
    
    load(fullfile(mat_files_event(ifolder).folder, mat_files_event(ifolder).name));
    load(fullfile(mat_files_data(ifolder).folder, mat_files_data(ifolder).name));
   
    % remove noisy trigger
    NOR = length(find(triggerValues==50)); % number of Reward
    keepValues = [10 20];
    index = ismember(triggerValues, keepValues);
    triggerValues = triggerValues(index);
    triggerTimes = triggerTimes(index);
        
    events = [10,20];
    names = {'Target','Standard'};
    sets = {'set I', 'set II', 'set III'};
    
    Fs = 1000;
    preOnsetDuration = 0.2;
    postOnsetDurtion = 0.7;
    
    preOnsetSamplesNum = ceil(preOnsetDuration*Fs); 
    postOnsetSamplesNum = ceil(postOnsetDurtion*Fs); 
    EpochedData = zeros(size(CleanData, 1),length(triggerValues),preOnsetSamplesNum + postOnsetSamplesNum + 1);

for iTrial = 1:size(EpochedData, 2)
    os =round(triggerTimes(iTrial) / 30);
    EpochedData(:,iTrial,:) = CleanData(:, os-preOnsetSamplesNum:os+postOnsetSamplesNum);
end
 
       
    for j=1:size(sets,2)
        Epoch.set(j).name = sets{j};
        for i=1:size(events,2)
            
            Epoch.set(j).events(i).trigger_index = find(triggerValues(1+100*(j-1):100*j) == events(i))+100*(j-1);
            Epoch.set(j).events(i).name = names{i};
            
        end
    end
    
    
Epoch.data = EpochedData;

save(fullfile(mat_files_data(ifolder).folder, '\normalizedEEGOverTime_EpochedData.mat'), 'Epoch');
end
