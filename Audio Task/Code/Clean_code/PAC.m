clc;
clear;
close all;

mat_files = dir(fullfile(pwd,'normalizedEEGOverTime_EpochedData.mat'));
if ~exist(fullfile(mat_files.folder,'PAC'), 'dir')
        mkdir(fullfile(mat_files.folder,'PAC'));
end

load(fullfile(mat_files.folder, mat_files.name));

eeg = Epoch.data;

for event = 1:2 % 1=target & 2= standard

    % Define window size and step
windowSize = 200; %fs=1000, so 200 means 200msec
overlap = 100;
numberchannel = 6;

numWindows = floor((length(eeg(1,1,:))-windowSize)/overlap)+1;

Fs = 1000;
pac =  nan(numberchannel,numWindows,3); % total time = 1 sec(200ms window with 100ms overlap) 3= number of set
CI_1 =  nan(numberchannel,numWindows,3);
CI_2 =  nan(numberchannel,numWindows,3);

for sets=1:3

indx = Epoch.set(sets).events(event).trigger_index; % target


epoch = eeg(:,indx,:);

epoch = permute(epoch,[1 3 2]);

%%%fs=1000;
epoch_mean_bs = mean(epoch(:,1:200,:),2);
epoch_demean = epoch - epoch_mean_bs;
erp = mean(epoch_demean,3);



high = [30 50]; % set the required amplitude frequency range
low = [5 8]; % set the required phase frequency range
highfreq = high(1):2:high(2);
amp_length = length(highfreq);
lowfreq = low(1):1:low(2);
phase_length = length(lowfreq);
tf_MVL_all = zeros(numberchannel,amp_length,phase_length);

 for cnt = 1:numWindows
    idx = (cnt-1)*overlap+1;
    x = erp(:,idx:idx+windowSize-1);
    for c = 1:numberchannel
        for k = 1:phase_length
            for j = 1:amp_length
                l_freq = lowfreq(k);
                h_freq = highfreq(j);
                [tf_MVL_all(c,j,k)] = tfMVL(x(c,:), h_freq, l_freq, Fs);
            end
        end
    end
    tf = tf_MVL_all(:,1:3,:);     %30-50 * 5-8 to 30-34 * 5*8   %% highfreq = high(1):2:high(2); shape tf = (3,4)
    
    tf_MVL_mean = mean(mean(tf,2),3); 
    pac(:,cnt,sets)=tf_MVL_mean;
    pac_v=reshape(tf, numberchannel,[]);
    trialnumber = length(pac_v(1,:));
    mean_sgn = mean(pac_v,2);
    std_sgn = std(pac_v,1,2)/sqrt(trialnumber);

    ts = tinv([0.025 0.975],trialnumber-1);
    CI_1(:,cnt,sets) = mean_sgn + ts(1) * std_sgn;
    CI_2(:,cnt,sets) = mean_sgn + ts(2) * std_sgn;

    
    
 end   
end
 
 for c = 1:numberchannel
     
     t= 1:numWindows;
     t= -200+overlap/2:overlap:(numWindows-1)*overlap-200+overlap/2;

     figure('Position', [0 0 800 600])
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
    title(strcat('PAC','\hspace{0.2cm} ',', window size: ' , num2str(windowSize), '\hspace{0.2cm} ', ', step: ',num2str(overlap), '\hspace{0.2cm}'...
,', channel: ',num2str(c),'\hspace{0.2cm}',Epoch.set(1).events(event).name),'interpreter','latex','fontsize',16);
    xlabel('Time (ms)','interpreter','latex','fontsize',14);
    xlim([-200+overlap/2 (numWindows-1)*overlap-200+overlap/2])
    xline(0, 'k--')       
    legend('CI1','Before','CI2','Reward','CI3','After','stimulus Onset','interpreter','latex')
    saveas(gcf,strcat(mat_files.folder,'\PAC\adynamic_pac',int2str(event),'_CH',int2str(c),'.png'))
    hold off;

       
    
 end
 
end

    
% % % %  
% % % %  
% % % %  
% % % % for c = 1:numberchannel % c : channels
% % % % 
% % % %     
% % % %  for cnt = 1:numWindows
% % % %      
% % % %      
% % % %     idx = (cnt-1)*overlap+1;
% % % %     x = data(idx:idx+windowSize-1);
% % % %     
% % % %     high = [30 50]; % set the required amplitude frequency range
% % % %     low = [5 8]; % set the required phase frequency range
% % % %     highfreq = high(1):2:high(2);
% % % %     amp_length = length(highfreq);
% % % %     lowfreq = low(1):1:low(2);
% % % %     phase_length = length(lowfreq);
% % % %     tf_MVL_all = zeros(amp_length,phase_length);
% % % % 
% % % %     for k = 1:phase_length
% % % %         for j = 1:amp_length
% % % %             l_freq = lowfreq(k);
% % % %             h_freq = highfreq(j);
% % % %             [tf_MVL_all(j,k)] = tfMVL(x, h_freq, l_freq, Fs);
% % % %         end
% % % %     end
% % % %     tf = tf_MVL_all(1:3,:);     %30-50 * 5-8 to 30-34 * 5*8   %% highfreq = high(1):2:high(2); shape tf = (3,4)
% % % %     
% % % %     final_matrix = max(final_matrix, tf);
% % % %     
% % % %     
% % % %     tf_MVL_mean = mean(mean(tf)); 
% % % %     pac(cnt)=tf_MVL_mean;
% % % %     
% % % %     pac_v=tf(:)';
% % % %     trialnumber = length(pac_v);
% % % %     mean_sgn = mean(pac_v);
% % % %     std_sgn = std(pac_v,1)/sqrt(trialnumber);
% % % % 
% % % %     ts = tinv([0.025 0.975],trialnumber-1);
% % % %     CI_1(cnt) = mean_sgn + ts(1) * std_sgn;
% % % %     CI_2(cnt) = mean_sgn + ts(2) * std_sgn;
% % % % 
% % % %  end
% % % %  
% % % % %     close all;
% % % % %     t= 1:numWindows;
% % % % %     figure('Position', [0 0 800 600])
% % % % %     curve1 = CI_2(:);
% % % % %     curve2 = CI_1(:);
% % % % %     t2 = [t, fliplr(t)];
% % % % %     inBetween = [curve1', fliplr(curve2')];
% % % % %     fill(t2, inBetween, 'b','FaceAlpha',0.3);
% % % % %     hold on;
% % % % %     %save(strcat('pac_CH',int2str(c),'std'),'pac')
% % % % %     xticklabels({'-200to-100' '-100to100' '0to200' '100to300' '200to400' '300to500' '400to600' '500to700'})
% % % % %     
% % % % %     plot(t,pac);
% % % % %     set(gcf,'Position',get(0,'Screensize'));
% % % % %     title(strcat('dynamic_event',int2str(eve),'__CH',int2str(c)));
% % % % %     saveas(gcf,strcat(mat_files(i).folder,'\PAC\dynamic_event',int2str(eve),'_CH',int2str(c),'set',int2str(se),'.png'))
% % % % %     hold off;
% % % %     
% % % %     pac_value(c,se,:)=reshape(final_matrix, [], 1);
% % % %     
% % % %     plt(:,c,se)=pac;
% % % % end
% % % % end
% % % % 
% % % % %%
% % % % t= 1:numWindows;
% % % % xticklabels({'-200to-100' '-100to100' '0to200' '100to300' '200to400' '300to500' '400to600' '500to700'})
% % % % for c=(1:4)
% % % %     
% % % %     
% % % %     plot(t,plt(:,c,1));
% % % %     hold on;
% % % %     plot(t,plt(:,c,2));
% % % %     hold on;
% % % %     plot(t,plt(:,c,3));
% % % %     legend('Before', 'Reward','After');
% % % % 
% % % %         
% % % %     set(gcf,'Position',get(0,'Screensize'));
% % % %     title(strcat('dynamic_event',int2str(eve),'__CH',int2str(c)));
% % % %     saveas(gcf,strcat(pwd,'\PAC\PAC',int2str(eve),int2str(c),'.png'))
% % % %     hold off
% % % % 
% % % % 
% % % % end
% % % % 
% % % % 
% % % % %%
% % % % pvalue=zeros(3,4); % #set=3 #channel=6
% % % % for c=(1:4)
% % % %     [h,P1,ci,stats] = ttest2(pac_value(c,1,:),pac_value(c,2,:));
% % % %     [h,P2,ci,stats] = ttest2(pac_value(c,1,:),pac_value(c,3,:));
% % % %     [h,P3,ci,stats] = ttest2(pac_value(c,2,:),pac_value(c,3,:));
% % % %     
% % % % %     [R1,P1] = corrcoef(pac_value(c,1,:),pac_value(c,2,:));
% % % % %     [R2,P2] = corrcoef(pac_value(c,1,:),pac_value(c,3,:));
% % % % %     [R3,P3] = corrcoef(pac_value(c,2,:),pac_value(c,3,:));
% % % %     pvalue(1,c)=P1;
% % % %     pvalue(2,c)=P2;
% % % %     pvalue(3,c)=P3;
% % % % end
% % % % 
% % % % M=pvalue;
% % % % col_labels={'1' ,'2', '3', '4', '5' ,'6'};
% % % % row_labels={'1-2', '1-3', '2-3'};
% % % % 
% % % % imagesc(M) % plot the matrix as an image
% % % % colorbar % add a colorbar
% % % % xticks(1:length(col_labels)) % set the x-axis ticks
% % % % xticklabels(col_labels) % set the x-axis labels
% % % % yticks(1:length(row_labels)) % set the y-axis ticks
% % % % yticklabels(row_labels) % set the y-axis labels
% % % % 
% % % % % Loop over the rows and columns of M and add text
% % % % [nrow,ncol] = size(M); % get the size of M
% % % % for i = 1:nrow % loop over rows
% % % %   for j = 1:ncol % loop over columns
% % % %     % Convert the number to a string and center it in the cell
% % % %     str = num2str(M(i,j));
% % % %     text(j,i,str,'HorizontalAlignment','center')
% % % %   end
% % % % end
% % % %     saveas(gcf,strcat(pwd,'\PAC\pvalue',int2str(eve),'.png'))
% % % % 
