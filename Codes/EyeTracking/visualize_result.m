clc; clear; close all

% load required data and variables
load('triggers.mat');
load('rawData30000');
load('matlab.mat')

%% 

successful_trials_val = strfind(triggerValues, [100,150,190,223]);
succ_trial_num = length(successful_trials_val);
fprintf ('number of successful trials = %d\n', succ_trial_num);

% cluster trials
reward_period_sam = triggerTimes(successful_trials_val + 2) - triggerTimes(successful_trials_val + 1) + 1;
reward_period_time = double(reward_period_sam) / fs;
reward_period_time = round(reward_period_time, 1);

%%

reward_pos_140 = zeros(140, 2);

for i=1:140
    angle_idx = trials(i).Rewsituation(1);
    reward_pos_140(i, :) = trials(i).positionMatrix(angle_idx, :);
end

trials_idx_1 = strfind(triggerValues,[150,190,223]);
trials_idx_2 = strfind(triggerValues,[190,223]);
diff_trial = setdiff(trials_idx_2, trials_idx_1+1);

diff_trial_idx = find(ismember(trials_idx_2, diff_trial));
reward_pos_138 = reward_pos_140;
reward_pos_138(diff_trial_idx, :) = [];

%% 

eye_tracks = eye_track_data(rawData, start_idx, end_idx, reward_period_time, reward_pos_138);

%% 

figure;
scatter_plot_eyeTrack(eye_tracks, "norm", 3, AttentionSpan, 0);

%%

reward_idx = 1:14;
figure;
for i=1:length(reward_idx)
    subplot(4,4,i, 'align');
    scatter_plot_eyeTrack(eye_tracks, "ext", reward_idx(i), AttentionSpan, 0);
end

%%

% plotting the accuracy of monkey looking after the reward position

rewards_accuracy = zeros(1,138);

for i=1:length(rewards_accuracy)
    
    loc = [rawData(9, start_idx(i):end_idx(i))' rawData(10, start_idx(i):end_idx(i))'] ./ 1000;
    loc = (loc ./ 5) .* [960, 540];
    eyePos = loc + [960, 540];
    
    rewardPos = reward_pos_138(i, :);
    dist_vec = eyePos - rewardPos;
    distance = sqrt(dist_vec(:,1).^2 + dist_vec(:,2).^2);
    
    rewards_accuracy(i) = sum(distance <= AttentionSpan) / length(eyePos) * 100;
    
end

figure;
bar(1:length(rewards_accuracy), rewards_accuracy);
title('Accuracy of monkey gazing at rewards')
xlabel('trials')
ylabel('accuracy percentage (%)')

%%

ext_reward_accuracy = zeros(1,14);

for i=1:length(ext_reward_accuracy)
    
    eyePos = eye_tracks.ext_reward_eye(:,:,i);
    valid_ind = find(eyePos >= 0);
    trimmed_data = eyePos(valid_ind);
    trimmed_data = reshape(trimmed_data, size(eyePos, 1), []);
    
    rewardPos = eye_tracks.ext_reward_pos(:, i);
    dist_vec = trimmed_data' - rewardPos';
    distance = sqrt(dist_vec(:,1).^2 + dist_vec(:,2).^2);
    
    ext_reward_accuracy(i) = sum(distance <= AttentionSpan) / length(trimmed_data) * 100;
    
end

figure;
bar(1:length(ext_reward_accuracy), ext_reward_accuracy);
title('Accuracy of monkey gazing at extended reward')
xlabel('trials')
ylabel('accuracy percentage (%)')

%%

norm_reward_accuracy = zeros(1,25);

for i=1:length(norm_reward_accuracy)
    
    eyePos = eye_tracks.norm_reward_eye(:,:,i);
    valid_ind = find(eyePos >= 0);
    trimmed_data = eyePos(valid_ind);
    trimmed_data = reshape(trimmed_data, size(eyePos, 1), []);
    
    rewardPos = eye_tracks.norm_reward_pos(:, i);
    dist_vec = trimmed_data' - rewardPos';
    distance = sqrt(dist_vec(:,1).^2 + dist_vec(:,2).^2);
    
    norm_reward_accuracy(i) = sum(distance <= AttentionSpan) / length(trimmed_data) * 100;
    
end

figure;
bar(1:length(norm_reward_accuracy), norm_reward_accuracy);
title('Accuracy of monkey gazing at normal reward')
xlabel('trials')
ylabel('accuracy percentage (%)')
