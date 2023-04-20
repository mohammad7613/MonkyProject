clc;
clear;
close all;

eve=30;

d = 'C:\Users\Fazeli\Desktop\Monkey\MonkeyData\MonkeyData_v1\Auditory\';

mat_files = dir(fullfile(d,strcat('**/Epoch_event_',int2str(eve),'.mat')));

for i = 1:length(mat_files)

    if ~exist(fullfile(mat_files(i).folder,'ERP'), 'dir')
        mkdir(fullfile(mat_files(i).folder,'ERP'));
        %mkdir(folder_paths{i});

    end
    
    eeg = load(fullfile(mat_files(i).folder, mat_files(i).name));
    event = eeg.data;
    trialnumber = size(event,3);

    event_mean_bs = mean(event(:,1:200,:),2);
    event_demean = event - event_mean_bs;
    S30 = mean(event_demean,3);
    std30 = std(event_demean,1,3)/sqrt(trialnumber);

    ts = tinv([0.025 0.975],trialnumber-1);
    CI_1 = S30 + ts(1) * std30;
    CI_2 = S30 + ts(2) * std30;


    t=-200:700;


    for c = 1:8
    
        % confidence interval plot
        curve1 = CI_2(c,:);
        curve2 = CI_1(c,:);
        t2 = [t, fliplr(t)];
        inBetween = [curve1, fliplr(curve2)];
        fill(t2, inBetween, 'b','FaceAlpha',0.3);
        hold on;   
        plot(t,S30(c,:),'LineWidth', 3);
        set(gcf,'Position',get(0,'Screensize'));
        title(strcat('ERP__event:',int2str(eve),'__CH:',int2str(c)));
        xlabel('time(ms)');
        saveas(gcf,strcat(mat_files(i).folder,'\ERP\event',int2str(eve),'_CH',int2str(c),'.png'))
        close all;
    end

end