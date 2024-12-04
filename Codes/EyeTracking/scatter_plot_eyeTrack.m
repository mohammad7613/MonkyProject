function scatter_plot_eyeTrack(eye_tracks, reward_type, idx, radius, isHistog)
    
    % select the data based on the reward type
    switch reward_type
        case "ext"
            data = eye_tracks.ext_reward_eye(:,:, idx);
            goal = eye_tracks.ext_reward_pos(:, idx);
        case "norm"
            data = eye_tracks.norm_reward_eye(:,:, idx);
            goal = eye_tracks.norm_reward_pos(:, idx);
        case "BG"
            data = eye_tracks.BG_reward_eye(:,:, idx);
            goal = eye_tracks.norm_reward_pos(:, idx);
    end
    
    % trim and exract valid data since the fact that trials have different
    % sample lengths
    valid_ind = find(data >= 0);
    trimmed_data = data(valid_ind);
    trimmed_data = reshape(trimmed_data, size(data, 1), []);
    fprintf("Number of samples = %d", length(trimmed_data))
    
    % check if the user wants a scatter plot or a 2-D histogram
    if isHistog == 0
        scatter(trimmed_data(1, :), trimmed_data(2, :), 'filled'); hold on;
    else
        histogram2(trimmed_data(1, :), trimmed_data(2, :), 'FaceColor','flat'); hold on;
        colorbar;
    end
    
    scatter(goal(1), goal(2)); % Plot goal point
    
    % Draw a circle around the goal point
    center = [goal(1), goal(2)]; % Center of the circle
    viscircles(center, radius, 'Color', 'r', 'LineStyle', '--');    
    
    hold off;
    
    set(gca, 'YDir', 'reverse')
    title("Scatter plot of eye tracks - " + reward_type + " reward - trial # " + num2str(idx))
    xlabel("pos 1")
    ylabel("pos 2")
    xlim([0 1920])
    ylim([0 1080])
    hLegend = legend('eye data', 'reward position');
    %set(hLegend, 'FontSize', 4);
    
end