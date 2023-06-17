clear;
%%
% xx = fileread('20220501-1154-res.txt');
% C = regexpi(x(:,3),'(\w)+.tif','tokens');
% C = cellfun(num2str(C));
x = readmatrix('20220501-1154-res','OutputType','string');
C = char(x(:, 3));
C = str2double(string(C(:, 1:2)));
res = [str2double(string(x)) C] ;

%% 
clear trigg
ix1 = find(triggerValues==1);
ntrial = 60;
ix1(diff(ix1)<ntrial)=[];

for i = 1:length(ix1)-1
    trigg{i,1}(:,1) = triggerValues(ix1(i):ix1(i+1)-1);
    trigg{i,2}(:,1) = triggerTimes(ix1(i):ix1(i+1)-1);
end
trigg{i+1,1}(:,1) = triggerValues(ix1(i+1):end);
trigg{i+1,2}(:,1) = triggerTimes(ix1(i+1):end);

for i = 1:length(trigg)
    trigg{i,2}(trigg{i,1}(ntrial+1:end,1),1) = trigg{i,2}(ntrial+1:end,1);
    trigg{i,1}(ntrial+1:end,:)=[];
    trigg{i,2}(ntrial+1:end,:)=[];
end
%% % Global Detrending

decimatedData = rawData;

for iChannel = 1:size(decimatedData, 1)
    p = polyfit(1:size(decimatedData, 2), decimatedData(iChannel, :), 1);
    decimatedData(iChannel, :) = decimatedData(iChannel, :) - ...
        p(1) * (1:size(decimatedData, 2)) - p(2);
end
clear p iChannel
%%
% Filtering Data
d = fdesign.notch(6, 50/500, 2.5);
Hd1 = design(d);

filteredData = nan(size(decimatedData));
for iChannel = 1:size(decimatedData, 1)
    filteredData(iChannel, :) = filtfilt(Hd1.sosMatrix, Hd1.ScaleValues, ...
        decimatedData(iChannel, :));
end
clear decimatedData d Hd1 iChannel
%% Epoching
EEGData = filteredData;
preOnsetSamples = 3000 - 1;
postOnsetSamples = 5000;
time = -preOnsetSamples:postOnsetSamples;
Neuralsig = [];

for nblock = 1:10
    for tag = 1:ntrial
        
        onsetTimes = trigg{nblock,2}(tag,1);
        os = round(onsetTimes / 30);
        trigg{nblock,3}(tag,:,:) = EEGData(:, os-preOnsetSamples:os+postOnsetSamples);
    end
    Neuralsig = [Neuralsig;trigg{nblock,3}];
end
%%
% ix_HF = find(ismember(Rr,1:9));
% ix_AF = find(ismember(Rr,10:18));
% ix_HB = find(ismember(Rr,19:28));
% ix_AB = find(ismember(Rr,29:37));
% ix_IN = find(ismember(Rr,38:74));
% ix_NF = find(ismember(Rr,10:74));
% ix_F = find(ismember(Rr,1:18));
% ix_all = find(ismember(Rr,1:74));
% ix_AA = 1:1550;

ix_F = find(ismember(res(:,4),1:20));
ix_IN = find(ismember(res(:,4),31:60));


%%
%
fs = 1000;
set(0, 'defaultTextInterpreter', 'latex')

%
wp      = [0.1, 1, 1, 30];
mags    = [0, 1, 0];
devs    = [0.05, 0.01, 0.05];
[n, Wn, beta, ftype] = kaiserord(wp, mags, devs, fs);
n       = n + rem(n,2);
b       = fir1(n, Wn, ftype, kaiser(n+1, beta), 'scale');

clear wp mags devs n Wn beta ftype
%%
for iChannel = 1:size(Neuralsig,2)
    x = squeeze(Neuralsig(:,iChannel,:));
    filtsig(:,iChannel,:) = filtfilt(b, 1, x')';
end

%%
timeInd = 3000-300:3000+1000;

figure('Units', 'centimeters', 'Position', [0, 0, 45, 21]);
hold all;
tl = tiledlayout('flow');
%axList = [];
for iChannel = 1:size(Neuralsig,2)
    %axList = [axList, nexttile];
    ix1 = ix_F;
    ix2 = ix_IN;
   % x = squeeze(Neuralsig(:,iChannel,:));
    x = squeeze(filtsig(:,iChannel,:));
    g1 = mean(x(ix1, timeInd), 1);
    g2 = mean(x(ix2, timeInd), 1);
    
    s1 = std(x(ix1, timeInd), [], 1) / sqrt(length(ix1));
    s2 = std(x(ix2, timeInd), [], 1) / sqrt(length(ix2));
    subplot(3,3,iChannel);
    hold on
    plot(time(timeInd), g1, 'LineWidth', 3, 'Color', [.000 .447 .741])
    hold on
    fill([time(timeInd), flip(time(timeInd))], ...
        [g1 - s1, flip(g1 + s1)], [.000 .447 .741], ...
        'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off')
    plot(time(timeInd), g2, 'LineWidth', 3, 'Color', [.635 .078 0.184])
    fill([time(timeInd), flip(time(timeInd))], ...
        [g2 - s2, flip(g2 + s2)], [.635 .078 0.184], ...
        'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off')
    title(strcat('Channel', ' ', num2str(iChannel)));
    grid on
    
end
legend({'face','no face'});

% %linkaxes(axList(1:end-1))
% yLim = ylim(axList(1));
% for ax = axList
%     plot(ax, [0, 0], yLim, 'k--', 'HandleVisibility', 'off')
%     fill(ax, [150, 200, 200, 150], [yLim(1), yLim(1), yLim(2), yLim(2)], ...
%         [0.5 0.5 0.5], 'FaceAlpha', .1, 'EdgeColor', 'none')
%     legend(ax, 'Face', 'Fish', 'Cherry')
%     xlabel(ax, 'time (ms)')
%     ylabel(ax, 'Amplitude ($\mu$V)')
%     xlim(ax, [-100, 300])
%     set(ax, 'YGrid', 'on')
%     xlabel(ax, 'time(ms)')
%     ylabel(ax, 'Amplitude($\mu$V)')
%     set(ax, 'FontSize', 12)
% end
% title(tl, 'Event Related Potetntials')
% subtitle(tl, strcat(monkeyName, ' : ', sessionDate, ' : ', nSession))
% saveas(gcf, fullfile(figDir, 'ERP-Face-NoFace.fig'))
% saveas(gcf, fullfile(figDir, 'ERP-Face-NoFace.png'))
% close gcf
% clear tl iChannel x timeInd g1 g2 ax axList yLim







