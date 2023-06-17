if ~exist('dataDir', 'var')
    dataDir = uigetdir([], 'Path to Mat Data Folder');
end
if ~exist('data', 'var')
    load(fullfile(dataDir, 'epochedData.mat'))
end

monkeyName  = string(regexp(dataDir, '\\Sessions\\([\w^\d]+)\\', 'tokens'));
sessionDate = string(regexp(dataDir, '\\(\d+)\\', 'tokens'));
nSession    = string(regexp(dataDir, '\\S(\d+)\\?', 'tokens'));

%
fs = 1000;
set(0, 'defaultTextInterpreter', 'latex')

%
wp      = [0.1, 1, 8, 13];
mags    = [0, 1, 0];
devs    = [0.05, 0.01, 0.05];
[n, Wn, beta, ftype] = kaiserord(wp, mags, devs, fs);
n       = n + rem(n,2);
b       = fir1(n, Wn, ftype, kaiser(n+1, beta), 'scale');

clear wp mags devs n Wn beta ftype

%
cmFile  = ls(fullfile(dataDir, '..', 'Info', '*.bhv2'));
cm = mlread(fullfile(dataDir, '..', 'Info', cmFile));

if length(cm) > size(data, 1)
    cm(size(data, 1)+1:end) = [];
end

% stm.fish = any([cm.Condition]' == 1:4, 2);
% stm.face = any([cm.Condition]' == 5:8, 2);
% stm.cher = any([cm.Condition]' == 9:12, 2);
stm.right = any([cm.Condition]' == 1:2:11, 2);
stm.left = any([cm.Condition]' == 2:2:12, 2);

clear infoDir cmFile cm cmNum

% Results Directory
figDir = fullfile(dataDir, '..', 'Figures');
if ~isfolder(figDir)
    mkdir(figDir)
end

%% Face No-Face ERP
timeInd = 3000-100:3000+300;

figure('Units', 'centimeters', 'Position', [0, 0, 45, 21])
tl = tiledlayout('flow');
axList = [];
for iChannel = 1:size(data, 3)
    axList = [axList, nexttile];
    x = filtfilt(b, 1, data(:, :, iChannel)')';
    g1 = mean(x(stm.face, timeInd), 1);
    g2 = mean(x(stm.fish, timeInd), 1);
    g3 = mean(x(stm.cher, timeInd), 1);
    
    s1 = std(x(stm.face, timeInd), [], 1) / sqrt(sum(stm.face)) * 1.96;
    s2 = std(x(stm.fish, timeInd), [], 1) / sqrt(sum(stm.fish)) * 1.96;
    s3 = std(x(stm.cher, timeInd), [], 1) / sqrt(sum(stm.cher)) * 1.96;
    
    plot(time(timeInd), g1, 'LineWidth', 3, 'Color', [.000 .447 .741])
    hold on
    fill([time(timeInd), flip(time(timeInd))], ...
        [g1 - s1, flip(g1 + s1)], [.000 .447 .741], ...
        'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off')
    plot(time(timeInd), g2, 'LineWidth', 3, 'Color', [.635 .078 0.184])
    fill([time(timeInd), flip(time(timeInd))], ...
        [g2 - s2, flip(g2 + s2)], [.635 .078 0.184], ...
        'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off')
    plot(time(timeInd), g3, 'LineWidth', 3, 'Color', [.850 .325 .098])
    fill([time(timeInd), flip(time(timeInd))], ...
        [g3 - s3, flip(g3 + s3)], [.850 .325 .098], ...
        'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off')
    title(strcat("Channel", " ", num2str(iChannel)))
end

linkaxes(axList(1:end-1))
yLim = ylim(axList(1));
for ax = axList
    plot(ax, [0, 0], yLim, 'k--', 'HandleVisibility', 'off')
    fill(ax, [150, 200, 200, 150], [yLim(1), yLim(1), yLim(2), yLim(2)], ...
        [0.5 0.5 0.5], 'FaceAlpha', .1, 'EdgeColor', 'none')
    legend(ax, 'Face', 'Fish', 'Cherry')
    xlabel(ax, 'time (ms)')
    ylabel(ax, 'Amplitude ($\mu$V)')
    xlim(ax, [-100, 300])
    set(ax, 'YGrid', 'on')
    xlabel(ax, 'time(ms)')
    ylabel(ax, 'Amplitude($\mu$V)')
    set(ax, 'FontSize', 12)
end
title(tl, "Event Related Potetntials")
subtitle(tl, strcat(monkeyName, " : ", sessionDate, " : ", nSession))
saveas(gcf, fullfile(figDir, "ERP-Face-NoFace.fig"))
saveas(gcf, fullfile(figDir, "ERP-Face-NoFace.png"))
close gcf
clear tl iChannel x timeInd g1 g2 ax axList yLim