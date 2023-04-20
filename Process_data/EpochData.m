clc;
clear;
close all;

event =30;

d = 'C:\Users\Fazeli\Desktop\Monkey\MonkeyData\MonkeyData_v1\Auditory\';
mat_files_event = dir(fullfile(d,'**/triggers.mat'));
mat_files_data = dir(fullfile(d,'**/CleanData/CleanData.mat'));

for i = 1:length(mat_files_data)
    
    load(fullfile(mat_files_event(i).folder, mat_files_event(i).name));
    load(fullfile(mat_files_data(i).folder, mat_files_data(i).name));
        
    % Epoching
    preOnsetSamples = 200 ;  % change 3000 to 200
    postOnsetSamples = 700;    % change 5000 to 700
    time = -preOnsetSamples:postOnsetSamples;
    
    onsetTimes = triggerTimes(triggerValues == event);

    data = nan(length(onsetTimes), preOnsetSamples + postOnsetSamples+ 1, ...
    size(CleanData, 1));
    for iTrial = 1:size(data, 1)
        os = round(onsetTimes(iTrial) / 30);
        data(iTrial, :, :) = CleanData(:, os-preOnsetSamples:os+postOnsetSamples)';
    end
    clear iTrial postOnsetSamples preOnsetSamples triggerTimes

    data = permute(data,[3 2 1]);

    % Saving Results
    save(fullfile(mat_files_data(i).folder, strcat('\Epoch_event_',int2str(event))), 'triggerValues', 'data', 'time');

end

