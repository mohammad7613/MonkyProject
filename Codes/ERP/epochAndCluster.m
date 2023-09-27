function epoched_data = epochAndCluster(rawData, epoch_limits, baseline_limits, event_indices, n_chan, fs, cluster_types, cluster_names, event_types)

    % EPOCHANDCLUSTER: Extracts epochs from raw data and clusters them
    % based on event types e.g. reward period
    % Inputs:
    %   - rawData: Matrix of raw data [n_chan x n_samples]
    %   - epoch_limits: Time limits for each epoch [start_time, end_time] in seconds
    %   - baseline_limits: Time limits for baseline within each epoch [start_time, end_time] in seconds
    %   - event_indices: Indices of events in the data matrix which will be
    %                    used for epoching 
    %   - n_chan: Number of channels
    %   - fs: Sampling frequency in Hz
    %   - cluster_types: Types of event clusters (containing the values)
    %   - cluster_names: Names assigned to each event cluster
    %   - event_types: Types of events corresponding to each event index
    %                  (value of the event type)
    % Output:
    %   - epoched_data: Struct containing the epoched data, organized by event clusters
    % Example:
    %   - epoched_data = epochAndCluster(rawData, [-0.5 4], [-0.5 0],
    %                                    event_indices, 10, fs, [1 0.2 0.1],
    %         ["ext_reward" "norm_reward" "BG_reward"], reward_period_time);
    
    
    % Calculate the number of samples per epoch and per baseline
    epoch_samples = round(epoch_limits * fs); % number of samples per epoch
    baseline_samples = round(baseline_limits * fs); % number of samples per baseline

    n_epochs = length(event_indices);
    n_points = epoch_samples(2) - epoch_samples(1) + 1;     % number of points per epoch
    epoched_data = struct();
    for i=1:length(cluster_types)
        n_cluster = sum(event_types==cluster_types(i));
        epoched_data.(cluster_names(i)) = zeros(n_chan, n_points, n_cluster);
    end
    
    indicies = ones(1, length(cluster_types));
    
    % Loop over each epoch and extract the data segment from the continuous data matrix
    for i = 1:n_epochs
        
        start_index = event_indices(i) + epoch_samples(1);           % start index of the epoch
        end_index = event_indices(i) + epoch_samples(2);             % end index of the epoch
        
        baseline_start_index = event_indices(i) + baseline_samples(1); % start index of the baseline within the epoch
        baseline_end_index = event_indices(i) + baseline_samples(2); % end index of the baseline within the epoch
        baseline_mean = mean(rawData(1:n_chan, baseline_start_index:baseline_end_index),2); % mean value of the baseline for each channel
        
        idx = strfind(cluster_types, event_types(i));
        epoched_data.(cluster_names(idx))(:,:,indicies(idx)) = rawData(1:n_chan, start_index:end_index) - baseline_mean;
        indicies(idx) = indicies(idx) + 1;
        
    end
    
end