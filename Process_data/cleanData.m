clc;
clear;
close all;

d = 'C:\Users\Fazeli\Desktop\Monkey\MonkeyData\MonkeyData_v1\Auditory\';
mat_files = dir(fullfile(d,'**/rawData30000.mat'));


for i = 1:length(mat_files)

    if ~exist(fullfile(mat_files(i).folder,'CleanData'), 'dir')
        mkdir(fullfile(mat_files(i).folder,'CleanData'));

    end

    eeg(i) = load(fullfile(mat_files(i).folder, mat_files(i).name));
    eeg1 = eeg(i).rawData;
    eeglab;
    EEG.etc.eeglabvers = '2022.1'; % this tracks which version of EEGLAB is being used, you may ignore it
     EEG = pop_importdata('dataformat','array','nbchan',0,'data','eeg1','setname','EEG','srate',30000,'pnts',0,'xmin',0);
     EEG = eeg_checkset( EEG );
     EEG = pop_resample( EEG, 1000);
     EEG = eeg_checkset( EEG );
     EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',70);
     EEG.setname='EEG resampled BP';
     EEG = eeg_checkset( EEG );
     EEG = pop_eegfiltnew(EEG, 'locutoff',49.5,'hicutoff',50.5,'revfilt',1);
     EEG.setname='EEG resampled BP nt';
     EEG = eeg_checkset( EEG );
     EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
     EEG.setname='EEG resampled BP nt ASR';
     EEG = eeg_checkset( EEG );
     EEG = pop_reref( EEG, []);
     EEG.setname='EEG resampled BP nt ASR Reref';
     EEG = eeg_checkset( EEG );
     EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
     EEG.setname='EEG resampled BP nt ASR Reref ASR';
     EEG = eeg_checkset( EEG );
     EEG = pop_reref( EEG, []);
     EEG.setname='EEG resampled BP nt ASR Reref ASR Reref';
     EEG = eeg_checkset( EEG );
     
     
     CleanData=normalize(EEG.data,2);
     fs = 1000;
     save(fullfile(mat_files(i).folder,'\CleanData\CleanData.mat'),'fs','CleanData');
     
     close all;
     clear EEG;
     
end
