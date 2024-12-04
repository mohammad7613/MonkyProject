function Eye_tracks = eye_track_data(rawData, start_idx, end_idx, reward_period_time, reward_pos)
    
    % count the number of trials for each reward type
    n_ext_reward = sum(reward_period_time==1);
    n_norm_reward = sum(reward_period_time==0.2);
    n_BG_reward = sum(reward_period_time==0.1);
    
    n_points = end_idx - start_idx + 1; % number of samples per trial
    n_traial = length(start_idx);
    
    Eye_tracks = struct( ...
            'ext_reward_eye', -1 * ones(2, max(n_points), n_ext_reward), ...
            'ext_reward_pos', zeros(2, n_ext_reward), ...
            'norm_reward_eye', -1 * ones(2, max(n_points), n_norm_reward), ...
            'norm_reward_pos', zeros(2, n_norm_reward), ...
            'BG_reward_eye', -1 * ones(2, max(n_points), n_BG_reward), ...
            'BG_reward_pos', zeros(2, n_BG_reward) ...
        );
    
    ext_rw_idx = 1;
    norm_rw_idx = 1;
    BG_rw_idx = 1;
    
    % Loop over each epoch and extract the data segment from the continuous data matrix
    for i = 1:n_traial
        
        % convert the location data from millivolts to pixels
        loc = [rawData(9, start_idx(i):end_idx(i))' rawData(10, start_idx(i):end_idx(i))'] ./ 1000;
        loc = (loc ./ 5) .* [960, 540];
        pos = loc + [960, 540];
          
        % assign the data segment to the corresponding reward type field
        switch reward_period_time(i)
            case 1
                Eye_tracks.ext_reward_eye(:, 1:n_points(i), ext_rw_idx) = pos';
                Eye_tracks.ext_reward_pos(:, ext_rw_idx) = reward_pos(i, :);
                ext_rw_idx = ext_rw_idx + 1;
            case 0.2
                Eye_tracks.norm_reward_eye(:, 1:n_points(i), norm_rw_idx) = pos';
                Eye_tracks.norm_reward_pos(:, norm_rw_idx) = reward_pos(i, :);
                norm_rw_idx = norm_rw_idx + 1;
            case 0.1
                Eye_tracks.BG_reward_eye(:, 1:n_points(i), BG_rw_idx) = pos';
                Eye_tracks.BG_reward_pos(:, BG_rw_idx) = reward_pos(i, :);
                BG_rw_idx = BG_rw_idx + 1;
        end
    end

end