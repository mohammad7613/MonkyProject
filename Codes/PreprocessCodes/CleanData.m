clc;
clear;
close all;
file_path_to_sessionData = pwd;
file_path = [pwd,'\sessionData.mat'];
load(file_path);
eeg_rat = channelData';
Highpass_low = 1;
Highpass_high = 70;
BurstCriterion = 20;
version = 2;

EEG.etc.eeglabvers = '2022.1'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_importdata('dataformat','array','nbchan',0,'data','eeg_rat','setname','Rat_eeg','srate',SampleRate,'pnts',0,'xmin',0);
%EEG = pop_resample( EEG, 1000);
EEG = pop_eegfiltnew(EEG, 'locutoff',Highpass_low,'hicutoff',Highpass_high);
%EEG = pop_eegfiltnew(EEG, 'locutoff',49.5,'hicutoff',50.5,'revfilt',1);
%EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion',5,'ChannelCriterion',0.8,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
%EEG = pop_reref( EEG, []);
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',BurstCriterion,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
%EEG = pop_reref( EEG, []);
EEG.setname='EEG_resampled_BP_ASR';
EEG.chanlocs(1).labels = 'HC';
EEG.chanlocs(2).labels = 'OT';
EEG.chanlocs(3).labels = 'MFC';

EEG = pop_saveset( EEG, 'filename',['presessionData_v',num2str(version)],'filepath',pwd);