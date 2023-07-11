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

% Setup sounds
echant=8000; duree=.2;

freq=440;
Tone(1,:)=sin(2*pi*freq*[1/echant:1/echant:duree]);

freq=660;
Tone(2,:)=sin(2*pi*freq*[1/echant:1/echant:duree]);

freq=300;
Tone(3,:)=sin(2*pi*freq*[1/echant:1/echant:duree]);

FANCYTONE=[Tone(1,:),Tone(2,:),Tone(3,:),Tone(2,:),Tone(1,:),Tone(2,:),Tone(3,:),Tone(2,:),Tone(1,:),Tone(2,:),Tone(3,:),Tone(2,:),Tone(1,:)];

%load('IADS_4_3AOB.mat','IADS_sound','IADS_frex');

%% ************************* OPEN WITH TONES *************************
tag_reward = 50;

Time_between_stimulus = 2;
Time_reward = 1;
reward_duration = 0.5;
trial = 100; 
session_nymber=3;

LOG = zeros(session_nymber , trial);
c = clock;
for seti=1:session_nymber  % 100 trials per set - - 200 total
    
    p = [0.5, 0.5];  % Probability vector
    % Generate n random numbers between 0 and 1
    r = rand(1, trial);
    % Generate a random vector with length trial and including 1,2
    MEGA = (r < p(1)) +1;
    
    pahandle0  = PsychPortAudio('Open',[],[],0, echant, 1);
    buhandle0 = PsychPortAudio('CreateBuffer', pahandle0 , Tone(2,:));
    pahandle1  = PsychPortAudio('Open',[],[],0, echant, 1);
    buhandle1 = PsychPortAudio('CreateBuffer', pahandle1 , Tone(1,:));
    pahandles=[pahandle0,pahandle1];
    buhandles=[buhandle0,buhandle1];
    
    for ai=1:length(MEGA)
        % -------------
        PsychPortAudio('FillBuffer', pahandles(MEGA(ai)) , buhandles(MEGA(ai)));
        PsychPortAudio('Start', pahandles(MEGA(ai)) , 1, 0, 1);
% Tagger        
        tag_bin = flip(decimalToBinaryVector((MEGA(ai))*10, 8));
%#        outputSingleScan(sessionHandler, tag_bin);
        tag_bin = flip(decimalToBinaryVector(0, 8));
%#        outputSingleScan(sessionHandler, tag_bin);

        if seti==2 && MEGA(ai) == 2
            %disp("reward");
            WaitSecs(Time_between_stimulus-Time_reward-reward_duration);
%#            outputSingleScan(shReward, 1);

            % sending Reward Tag
            tag_bin = flip(decimalToBinaryVector(tag_reward, 8));
%#            outputSingleScan(sessionHandler, tag_bin);
            tag_bin = flip(decimalToBinaryVector(0, 8));
%#            outputSingleScan(sessionHandler, tag_bin);

            WaitSecs(reward_duration)    
%#            outputSingleScan(shReward, 0);
            WaitSecs(Time_reward);
        else
            WaitSecs(Time_between_stimulus);
        end


        LOG(seti,ai)=MEGA(ai):
%         io64(ioObject,LTP1address,0);
    end
    WaitSecs(60)

end
save([datestr(now, 'yyyy-mm-dd_HH-MM-SS'),'.mat']','LOG');

sca;
ShowCursor;
fprintf('\nEnd of Task.\n');
close all;

ListenChar(0);
