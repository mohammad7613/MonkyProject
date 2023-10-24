clc;
clear;
close all;

mat_files = dir(fullfile(pwd,'normalizedEEGOverTime_EpochedData.mat'));
if ~exist(fullfile(mat_files.folder,'ERP'), 'dir')
        mkdir(fullfile(mat_files.folder,'ERP'));
end

load(fullfile(mat_files.folder, mat_files.name));
eeg = Epoch.data;

for event = 1:2 % 1=target & 2= standard


numberchannel = 6;
time = -200:700;


Fs = 1000;
erp =  nan(numberchannel,lenght(time),3); % total time = 1 sec(200ms window with 100ms overlap) 3= number of set
CI_1 =  nan(numberchannel,lenght(time),3);
CI_2 =  nan(numberchannel,lenght(time),3);

for sets=1:3

indx = Epoch.set(sets).events(event).trigger_index; % target


epoch = eeg(:,indx,:);

epoch = permute(epoch,[1 3 2]);

%%%fs=1000;

trialnumber = size(epoch,3);
epoch_mean_bs = mean(epoch(:,1:200,:),2);
epoch_demean = epoch - epoch_mean_bs;
erp(:,:,sets) = mean(epoch_demean,3);

s30 = mean(epoch_demean,3);
std30 = std(epoch_demean,1,3)/sqrt(trialnumber);
ts = tinv([0.025 0.975],trialnumber-1);
CI_1(:,:,sets) = S30 + ts(1) * std30;
CI_2(:,:,sets) = S30 + ts(2) * std30;
t2 = [time, fliplr(time)];
inBetween = [curve1, fliplr(curve2)];
fill(t2, inBetween, 'b','FaceAlpha',0.3);
hold on
plot(time,movmean(S30(1,:), 30),'LineWidth', 3);
hold on
    
 end   

 
 for c = 1:numberchannel
     
     figure('Position', [0 0 800 600])
     time = -200:700;
     
     for sets= 1:3
        curve1 = CI_2(c,:,sets);
        curve2 = CI_1(c,:,sets);
        t2 = [t, fliplr(t)];
        inBetween = [curve1(:)', fliplr(curve2(:)')];
        fill(t2, inBetween, 'g','FaceAlpha',0.3);
        hold on;
        plot(t,pac(c,:,sets),'LineWidth',1.5);
        hold on;
     end
    %xticklabels({'-200to-100' '-100to100' '0to200' '100to300' '200to400' '300to500' '400to600' '500to700'})
    set(gcf,'Position',get(0,'Screensize'));
    title(strcat('ERP','\hspace{0.2cm} ',',', 'channel:' ,num2str(c),'\hspace{0.2cm}',Epoch.set(1).events(event).name),'interpreter','latex','fontsize',16);
    xlabel('Time (ms)','interpreter','latex','fontsize',14);
    %xlim([-200+overlap/2 (numWindows-1)*overlap-200+overlap/2])
    xline(0, 'k--')       
    legend('CI1','Before','CI2','Reward','CI3','After','stimulus Onset','interpreter','latex')
    saveas(gcf,strcat(mat_files.folder,'\ERP\ERP',int2str(event),'_CH',int2str(c),'.png'))
    hold off;

       
 end
 end
 
