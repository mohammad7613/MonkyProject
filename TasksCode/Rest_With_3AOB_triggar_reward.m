%%  Resting EEG for Brain Vision with 3 sounds: JFC 4/24/15

% 1 min eyes close
% 1 min eyes open (can get blinks...)

clear all;
close all;

% *************************************  Initialize EEG triggers
% ioObject = io64;
% LTP1address = hex2dec('C050');
% status = io64(ioObject);
% io64(ioObject,LTP1address,0); 
% *************************************

InitializePsychSound(1);

% set the random seed
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

% get the screen pointer
screen = 1;
% #####################
screenRect = [];
% #####################
% My change
% Screen('Preference', 'SkipSyncTests', 1)
% % My change 
% [wPtr,rect] = Screen('OpenWindow',screen, [], screenRect);
% black=BlackIndex(wPtr);
% Screen('FillRect',wPtr,black);
% Screen(wPtr, 'Flip');
% % get the center point for presentation purposes
% X_center = rect(3)/2;
% Y_center = rect(4)/2;

% Setup sounds
echant=8000; duree=.2;

freq=440;
Tone(1,:)=sin(2*pi*freq*[1/echant:1/echant:duree]);

freq=660;
Tone(2,:)=sin(2*pi*freq*[1/echant:1/echant:duree]);

freq=300;
Tone(3,:)=sin(2*pi*freq*[1/echant:1/echant:duree]);

FANCYTONE=[Tone(1,:),Tone(2,:),Tone(3,:),Tone(2,:),Tone(1,:),Tone(2,:),Tone(3,:),Tone(2,:),Tone(1,:),Tone(2,:),Tone(3,:),Tone(2,:),Tone(1,:)];

% load('Y:\Tasks\PDDys Suite\IADS_4_3AOB.mat','IADS_sound','IADS_frex');
% my change
% load('C:\Users\win10\Desktop\Javad\Auditory_oddball_task\IADS_4_3AOB.mat','IADS_sound','IADS_frex');
load('IADS_4_3AOB.mat','IADS_sound','IADS_frex');
flag = 0;
% my change
%% Experimenter instructions
% Screen('TextSize',wPtr,30);
% Screen('TextFont',wPtr,'Times');
% Screen('TextStyle',wPtr,0);
% Screen('TextColor',wPtr,[255 255 255]);
% beginningText1 = 'Experimenter: Continue';
% DrawFormattedText(wPtr,beginningText1,'center','center');
% Screen(wPtr, 'Flip');
% KbWait([],3); %Waits for keyboard(any) press
% 
% instructionText = 'Welcome and thank you for participating in our study. \n\n\n We are going to start by recording some activities \n\n of your brain activity at rest.';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
% KbWait([],3); %Waits for keyboard(any) press
% 
% instructionText = 'All you need to do is sit and rest quietly. \n\n\nWe will be recording resting EEG with your eyes \n\n\n CLOSED for the next minute. \n\n\n A tone will sound to let you know when \n\nthe time is up.';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
% KbWait([],3); %Waits for keyboard(any) press
% 
% % CLOSED
% DrawFormattedText(wPtr,'Close Eyes','center','center'); Screen(wPtr, 'Flip'); WaitSecs(1);
% % for ai=1:30
% %     io64(ioObject,LTP1address,3);  WaitSecs(.05);  io64(ioObject,LTP1address,0); WaitSecs(.95);
% %     io64(ioObject,LTP1address,4);  WaitSecs(.05);  io64(ioObject,LTP1address,0); WaitSecs(.95);
% % end
% sound(Tone(1,:),echant);
% 
% instructionText = 'Now another minute with your eyes OPEN.';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
%  KbWait([],3); %Waits for keyboard(any) press
% 
% % OPEN
% DrawFormattedText(wPtr,' + ','center','center'); Screen(wPtr, 'Flip'); WaitSecs(1);
% % for ai=1:30
% %     io64(ioObject,LTP1address,1);  WaitSecs(.05);  io64(ioObject,LTP1address,0); WaitSecs(.95);
% %     io64(ioObject,LTP1address,2);  WaitSecs(.05);  io64(ioObject,LTP1address,0); WaitSecs(.95);
% % end
% sound(Tone(1,:),echant);
% 
% instructionText = 'Great.  Now we are going to record again for TWO blocks \n\n that are each FOUR MINUTES long. \n\n\n\n\n In a moment you will hear some more tones.';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
%  KbWait([],3); %Waits for keyboard(any) press
% % 
% instructionText = 'Most tones will be low';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
% sound(Tone(1,:),echant); WaitSecs(1);  sound(Tone(1,:),echant); WaitSecs(1); sound(Tone(1,:),echant); WaitSecs(1); sound(Tone(1,:),echant);
% KbWait([],3); %Waits for keyboard(any) press
% 
% instructionText = 'A few tones will be HIGH \n\n\n we want you to KEEP COUNT \n\n of how many times you hear the high tone.';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
% sound(Tone(1,:),echant); WaitSecs(1);  sound(Tone(1,:),echant); WaitSecs(1); sound(Tone(1,:),echant); WaitSecs(1); sound(Tone(2,:),echant);
% KbWait([],3); %Waits for keyboard(any) press
% 
% instructionText = 'Some tones will be odd. \n\n\n We want you to IGNORE  \n\n these weird ones.';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
% sound(IADS_sound{41},IADS_frex{41}); WaitSecs(1);  sound(IADS_sound{42},IADS_frex{42}); WaitSecs(1); sound(IADS_sound{43},IADS_frex{43});
% KbWait([],3); %Waits for keyboard(any) press
% 
% instructionText = 'You only need to \n\n\n KEEP COUNT \n\n of how many times you hear the high tone.';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
% sound(Tone(1,:),echant); WaitSecs(1);  sound(IADS_sound{44},IADS_frex{44});  WaitSecs(1); sound(Tone(1,:),echant); WaitSecs(1); sound(Tone(2,:),echant);
% KbWait([],3); %Waits for keyboard(any) press
% 
% instructionText = 'You will hear this FANCY TONE \n\n\n when it is time to call the experimenter:';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
% sound(FANCYTONE,echant);
% KbWait([],3); %Waits for keyboard(any) press
% 
% instructionText = 'You will be asked to report your count \n\n of HIGH tones at the end!! \n\n\n\n You can keep your eyes fixated \n\n on the "+"';
% DrawFormattedText(wPtr,instructionText,'center','center');
% Screen(wPtr, 'Flip');
% KbWait([],3); %Waits for keyboard(any) press
% definision of sessoion 
% sessionHandler = daq.createSession('ni');
% [chTag, idxTag] = addDigitalChannel(sessionHandler, ...
%     'Dev1', 'Port0/Line0:7', 'OutputOnly');

% ************************* OPEN WITH TONES *************************
tag_reward = 50;

Time_between_stimulus = 2;
Time_reward = 1;
reward_duration = 0.5;
A=[1,1,0];B=[1,1,1,0];C=[1,1,1,1,0];D=[1,1,1,1,1,0];
E=[1,1,2];F=[1,1,2];G=[1,1,2];H=[1,1,1,2];
I=[1,2,1,1,1,0];J=[1,1,2,1,1,0];K=[1,1,2,1,0];L=[1,2,1,0];
ncount=1;
c = clock;
a_p_1 = c(6);
counter = 0;
ti = zeros(1,200);
for seti=1:2  % 100 trials per set - - 200 total
    tonejitters=repmat(Shuffle(.5:.005:1),1,2);
    
    MEGA=[];
    for shuffi=1:2
        tonetypes=Shuffle([{A},{B},{C},{D},{E},{F},{G},{H},{I},{J},{K}]);
        MEGA=[MEGA,tonetypes{1},tonetypes{2},tonetypes{3},tonetypes{4},tonetypes{5},tonetypes{6},tonetypes{7},...
            tonetypes{8},tonetypes{9},tonetypes{10},tonetypes{11}];
        clear tonetypes;
    end
    % To get to a nice 100 trials with 15 Novels and 15 Oddballs
    MEGA=[MEGA,L];
    
    pahandle0  = PsychPortAudio('Open',[],[],0, echant, 1);
    buhandle0 = PsychPortAudio('CreateBuffer', pahandle0 , Tone(2,:));
    pahandle1  = PsychPortAudio('Open',[],[],0, echant, 1);
    buhandle1 = PsychPortAudio('CreateBuffer', pahandle1 , Tone(1,:));
    
%     DrawFormattedText(wPtr,' + ','center','center'); Screen(wPtr, 'Flip'); WaitSecs(1);
    for ai=1:length(MEGA)
        pahandle2 = PsychPortAudio('Open',[],[],0, IADS_frex{ncount}, 1);
        buhandle2 = PsychPortAudio('CreateBuffer', pahandle2 , IADS_sound{ncount}');
        pahandles=[pahandle0,pahandle1,pahandle2];
        buhandles=[buhandle0,buhandle1,buhandle2];
        % -------------
        PsychPortAudio('FillBuffer', pahandles(MEGA(ai)+1) , buhandles(MEGA(ai)+1));
%         io64(ioObject,LTP1address,200+MEGA(ai));
        PsychPortAudio('Start', pahandles(MEGA(ai)+1) , 1, 0, 1);
% Tagger        
        tag_bin = flip(decimalToBinaryVector((MEGA(ai)+1)*10, 8));
        outputSingleScan(sessionHandler, tag_bin);
        tag_bin = flip(decimalToBinaryVector(0, 8));
        outputSingleScan(sessionHandler, tag_bin);
%         c = clock;
%          a_p_1 = c(6);
        if flag == 1 && MEGA(ai)+ 1 == 3
            WaitSecs(Time_between_stimulus-Time_reward-reward_duration);
            outputSingleScan(shReward, 1);

            tag_bin = flip(decimalToBinaryVector(tag_reward, 8));
            outputSingleScan(sessionHandler, tag_bin);
            tag_bin = flip(decimalToBinaryVector(0, 8));
            outputSingleScan(sessionHandler, tag_bin);

            WaitSecs(reward_duration)    
            outputSingleScan(shReward, 0);
            WaitSecs(Time_reward);
        end
        WaitSecs(Time_between_stimulus-Time_reward-reward_duration);

        tag_bin = flip(decimalToBinaryVector(tag_reward, 8));
        outputSingleScan(sessionHandler, tag_bin);
        tag_bin = flip(decimalToBinaryVector(0, 8));
        outputSingleScan(sessionHandler, tag_bin);

        WaitSecs(reward_duration)    

        WaitSecs(Time_reward);
%         c = clock;
%         a_p_2 = c(6);
%         counter = counter +1;
%         ti(counter) = a_p_2 - a_p_1
        if MEGA(ai)+1==3
            ncount=ncount+1;
            PsychPortAudio('Stop', pahandles(MEGA(ai)+1));
            PsychPortAudio('Close', pahandles(MEGA(ai)+1));
        end
        LOG(seti,ai)=MEGA(ai);
%         io64(ioObject,LTP1address,0);
    end
%     WaitSecs(2);
    
    
    
    
%     sound(FANCYTONE,echant);
    
    % ------------------------------------------------------------
%     instructionText = 'How many HIGH tones did you count?';
    %DrawFormattedText(wPtr,instructionText,'center','center');
    %Screen(wPtr, 'Flip');
%     KbWait([],3); %Waits for keyboard(any) press
    
%     if seti==1
% %         instructionText = 'OK - get ready for the SECOND  \n\n block of tones.';
% %         DrawFormattedText(wPtr,instructionText,'center','center');
% %         Screen(wPtr, 'Flip');
% %         KbWait([],3); %Waits for keyboard(any) press
% %         
% %         instructionText = 'You will be asked to report your count \n\n of HIGH tones at the end! \n\n\n You can keep your eyes fixated \n\n on the "+" \n\n\n\n Experimenter press space when ready.';
% %         DrawFormattedText(wPtr,instructionText,'center','center');
% %         Screen(wPtr, 'Flip');
% %         KbWait([],3); %Waits for keyboard(any) press
%     end
end
save([datestr(now, 'yyyy-mm-dd_HH-MM-SS'),'.mat']','LOG');

%*******FORCE STOP**********
% wait_text = 'Done! \n\n\n  You can call for the experimenter now.';
% Screen('TextFont',wPtr,'Times New Roman');
% Screen('TextStyle',wPtr,0);
% Screen('TextColor',wPtr,[255 255 255]);
% Screen('TextSize',wPtr,28);
% DrawFormattedText(wPtr,wait_text,'center','center');
% Screen(wPtr, 'Flip');
% KbWait([],3); %Waits for keyboard(any) press

sca;
ShowCursor;
fprintf('\nEnd of Task.\n');
close all;

ListenChar(0);


%%

% % cd('Y:\Tasks\IAPS and IADS JFC Download Fall 2014\IADS2007\IADS2 Sounds\');
% % sounds=dir('*.wav');
% % Irow=1;
% % for iadsnum=[1,2,4:11,13,15:23,27,29:31,33:36,39:40,46,48,49,50,51,53,54,55,56,58,59,60,61,65,66,67]
% %     [tx_sound, tx_frex, tx_bits] = wavread(sounds(iadsnum).name);
% %     IADS_sound{Irow} = tx_sound(2000:2000+round(length(tx_sound)/30));
% %     IADS_frex{Irow} = tx_frex;
% %     Irow=Irow+1;
% %     clear tx*
% % end
% % cd('Y:\Tasks\Rest'); save('IADS_4_3AOB.mat','IADS_sound','IADS_frex');