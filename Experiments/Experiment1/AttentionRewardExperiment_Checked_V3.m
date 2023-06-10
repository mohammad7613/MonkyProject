%% Refreshing the Workspace
close all
clear
clc

addpath('Task Functions')

%% Subject Information
recordingDir = 'E:\Code\Heidari\recording';

subjectName = inputdlg("Enter Subject Name");
subjectName = subjectName{1};
SessionName = inputdlg("Enter Session");
SessionName = SessionName{1};
%subjectName = "Test";

sessionDateTime = datestr(datetime('now'), 'yyyymmdd-HHMM');


if ~isfolder(fullfile(recordingDir, subjectName,sessionDateTime(1:8),SessionName))
    mkdir(fullfile(recordingDir, subjectName, ...
        sessionDateTime(1:8), SessionName))
end

sessionDir = fullfile(recordingDir, subjectName,sessionDateTime(1:8),SessionName);

%% Declare Global Variables
global Params
Params.isStarted            = false;
Params.isPaused             = false;
Params.isStopped            = false;
Params.manualReward         = false;
Params.fillPipe             = false;
Params.isCerePlexConnected  = false;
Params.xOffset              = 0;
Params.yOffset              = 0;
Params.fixationRadius       = 2;%My change
Params.fixationArea         = 0;
Params.rewardInterval       = 0;
Params.rewardDuration       = 0;
Params.acceptDuration       = 0;
Params.waitPunish           = 0;
Params.stimulusSize         = 3;
% My Change 
Params.FoucsTimeToGetReward = 0.4; % it needs to be lower than peresetation time
%%
global FIX_START FIX_BREAK STM_OFFSET TRL_SUCCESS TRL_FAILURE SESSION_START STM_ONSET REWARD_ONSET REWARD_OFFSET EYE_TRIGGER 
FIX_START   = 220;
FIX_BREAK   = 221;
STM_ONSET  =  100;
STM_OFFSET  = 200;
TRL_SUCCESS = 223;
TRL_FAILURE = 224;
SESSION_START = 225;
EYE_TRIGGER = 110;
% My Change 
REWARD_ONSET = 150;
REWARD_OFFSET = 190;

%% Task Parameters and Constants
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);

% Connections
connectToControllerServer   = true;
connectToEyeTracker         = true;
connectToRewardPump         = true;
sendTriggers                = true;

% Paradigm Constants
global duration
duration.triggerPulseWidth = .01;
duration.presentation = 3  - duration.triggerPulseWidth;
duration.fixation = .01;
duration.rest = 2 - duration.triggerPulseWidth;
duration.punish = 0.5 - duration.triggerPulseWidth;
duration.reward = 0.1;
duration.normal_rest = 1;

% Environment Constants
monitorWidth = 535;                                                         % in milimeters
monitorDistance = 500;                                                      % in milimeters

screenPtr = 1;

resolution      = Screen('Resolution', screenPtr);
screenWidth     = resolution.width;
screenHeight    = resolution.height;
pixelDepth      = resolution.pixelSize;
screenHz        = resolution.hz;
nScreenBuffers  = 2;

% My Parameter
% It should change based visual angle
% hstimSize = 81;
% wstimSize = 81;
% hDistance = 20;
% wDistance = 20;
temp = ang2pix(Params.stimulusSize , monitorDistance, monitorWidth / screenWidth);
hstimSize = temp; 
wstimSize = temp;
hDistance = 20;
wDistance = 20;

R = 300;

%% Connect To Controller Server
daqIp = '192.168.0.3';
Params.isCerePlexConnected  = false;
if connectToControllerServer
    if ~exist('Connection1', 'var')
        Connection1 = udp(daqIp, 'RemotePort', 3005, 'LocalPort', 3002);
        Connection1.Timeout=0.1;
        Connection1.BytesAvailableFcn = @CheckRecievedCommands;
        set(Connection1, 'InputBufferSize', 64);
        set(Connection1, 'OutputBufferSize', 64);
    else
        fclose(Connection2);
    end
    
    if ~exist('Connection2','var')
        Connection2 = udp(daqIp, 'RemotePort', 6025, 'LocalPort', 6022);
        Connection2.Timeout=0.1;
        Connection2.BytesAvailableFcn = @CheckRecievedCommands;
        set(Connection2, 'InputBufferSize', 64);
        set(Connection2, 'OutputBufferSize', 64);
    else
        fclose(Connection2);
    end
    
    if strcmp(Connection2.Status, 'closed')
        fopen(Connection2);
    end
    
    if strcmp(Connection1.Status, 'closed')
        fopen(Connection1);
    end
    
    while ~Params.isCerePlexConnected
        disp("Cannot connect to Data-Acquisition System")
        WaitSecs(1);
    end
    
    clc
    disp('Connected to Controller Server!')
    
    %     fprintf(Connection1, num2str(monitorDistance));
    %     fprintf(Connection1, num2str(monitorWidth));
    %     fprintf(Connection1, num2str(screenWidth));
    %     fprintf(Connection1, num2str(screenHeight));
else
    Params.isStarted = true;
end
  
%% Connect to Reward Pump
if connectToRewardPump
    shReward = daq.createSession('ni');
    [chReward, idxReward] = addDigitalChannel(shReward, ...
        'Dev1', 'Port1/Line0', 'OutputOnly');
end

if sendTriggers
    shTag = daq.createSession('ni');
    [chTag, idxTag] = addDigitalChannel(shTag, ...
        'Dev1', 'Port0/Line0:7', 'OutputOnly');
end

%% Psychtoolbox Initialization
[winPtr, winRect] = PsychImaging(...
    'OpenWindow', ...
    screenPtr, ...
    WhiteIndex(screenPtr) / 2, ...
    floor([0, 0, screenWidth, screenHeight] / 1), ...
    pixelDepth, ...
    nScreenBuffers, ...
    [], ...
    [], ...
    kPsychNeed32BPCFloat...
    );

% stmSize = 5;                                                                % in visual angles

[cX, cY] = WindowCenter(winPtr);
[normBoundsRect, ~, textHeight, xAdvance] = Screen('TextBounds', ...
    winPtr, ...
    'Paused', ...
    cX, ...
    cY);
% MyChange 
centerPoint = [winRect(3)/2,winRect(4)/2,winRect(3)/2,winRect(4)/2];
clear resolution nScreenBuffers pixelDepth ans\
%% Loading the Conditions
% stimDir = 'Stimulus_V3';
% stimNames = ls(fullfile(pwd, stimDir, '*.tif'));
% 
% stimTextures = containers.Map;
% for stim = 1:size(stimNames, 1)
%     
%     stimImg = imread(fullfile(pwd, stimDir, stimNames(stim, :)));
%     stimTextures(stimNames(stim, :)) = Screen('MakeTexture', ...
%         winPtr, ...
%         stimImg);
% end
% stimDir = 'Stimulus_V3_1_2';
stimDir = 'Stimulus';
stimNames = ls(fullfile(pwd, stimDir, '*.tif'));

stimTextures = containers.Map;
for stim = 1:size(stimNames,1)
    stimImg = imread(fullfile(pwd, stimDir, stimNames(stim, :)));
%     index = zeros(size(stimImg));
%     index(:,:,1) = (stimImg(:,:,1) == 0) & (stimImg(:,:,2) == 0) & (stimImg(:,:,3) == 0);
%     index(:,:,2) = (stimImg(:,:,1) == 0) & (stimImg(:,:,2) == 0) & (stimImg(:,:,3) == 0) ;
%     index(:,:,3) = (stimImg(:,:,1) == 0) & (stimImg(:,:,2) == 0) & (stimImg(:,:,3) == 0) ;
%     index = (index ==1);
%     stimImg(index) = 128;
%     stimImg((stimImg(:,:,1) == 0) & (stimImg(:,:,2) == 0) & (stimImg(:,:,3) == 0)) = 100;
    stimTextures(stimNames(stim, :)) = Screen('MakeTexture', ...
        winPtr, ...
        stimImg);  
end

%clear stimImg stim stimDir

%%
% nRep     = 1;
% nStimuli = length(stimTextures);
% assert(nStimuli < 200);

%% Creating the Condition Map
% stimNames = string(stimNames);
% clear trials
% for iStimuli = 1:nStimuli
%     trials(iStimuli).name = stimNames(iStimuli); %#ok<SAGROW>
%     trials(iStimuli).onset = NaN; %#ok<SAGROW>
%     trials(iStimuli).index = iStimuli; %#ok<SAGROW>
%     trials(iStimuli).stmSize = NaN;
% end
% trials = repmat(trials, 1, nRep);
% trials = trials(randperm(length(trials)));
% 
% nTrial = length(trials);
num_stimulus = 162;
trials = struct.empty(num_stimulus,0);
dimention_number = 3;
feature_number = 4;
angle_state_num = 6;

angle_states = [60/180*pi,180/180*pi,300/180*pi];
angle_states_combination = [[1,2,3];[3,1,2];[2,3,1];[2,1,3];[3,2,1];[1,3,2]];

winRect = [1990,812,1990,812];
centerPoint = [winRect(3)/2,winRect(4)/2,winRect(3)/2,winRect(4)/2];
R = 300;
c = 1;
RewardDimention = 3;
RewardFeature = 2;
for i=1:feature_number
    for j=1:feature_number
        for k=1:feature_number
            for angle=1:angle_state_num
                trials(c).matrix = zeros(3,1);
                trials(c).matrix(1,:) = i;
                trials(c).matrix(2,:) = j;
                trials(c).matrix(3,:) = k;
                trials(c).angle = zeros(3,1);
                trials(c).angle(1,1) = angle_states(angle_states_combination(angle,1));
                trials(c).angle(2,1) = angle_states(angle_states_combination(angle,2));
                trials(c).angle(3,1) = angle_states(angle_states_combination(angle,3));
                trials(c).onset =1;
                trials(c).positionMatrix = zeros(3,2);
                
                for g = 1:size(trials(c).positionMatrix,1)
                    centerPoint_stm = centerPoint(1:2) + [-R*sin(trials(c).angle(g)),-R*cos(trials(c).angle(g))%,-R*sin(trials(iTrial).angle(g)),-R*cos(trials(iTrial).angle(g))
                    ];
                    trials(c).positionMatrix(g,:) = centerPoint_stm;
                end
                
                % Chooce in which dimention and which feature have reward
                % with more probability
                if(trials(c).matrix(RewardDimention,1)==RewardFeature)
                    trials(c).RewProb = 1;
                else
                    trials(c).RewProb = 0.0;
                end
                c=c+1;
            end    
        end
    end
end
% trials = trials(1:10);

nTrial = length(trials);
trials = trials(randperm(nTrial));

%% Eye Tracker Initialization
eye_calibration(connectToEyeTracker, winRect, winPtr, subjectName);

%% Task Body
IDLE        = 0;
FIXATING    = 1;
PRESENTING  = 2;
RESTING     = 3;
PUNISHING   = 4;
FINISHING   = 5;
PAUSING     = 6;
%My change
REWARD = 7;
% pump state
GRANTING    = 20;
USURPING    = 21;

% fixPoint = [winRect(3) / 2, winRect(4) / 2];
gazeLoc  = [winRect(3) / 2, winRect(4) / 2];

fixTimer = tic;
stmTimer = tic;
punTimer = tic;
rstTimer = tic;
daqTimer = tic;
rewTimer = tic;
pmpTimer = tic;
rewardTimer = tic;


% fixCross = [cX - 2, cY - 10, cX + 2, cY + 10; ...
%     cX - 10, cY - 2, cX + 10, cY + 2];
% fixCrossColor = WhiteIndex(screenPtr) / 2 - 0.4;

if connectToControllerServer
    taskState = PAUSING;
else
    taskState = IDLE;
end
isFixated = false;
% My change
isFocused = false;

isChanged = true;
isPumpStateChanged = false;

% My new Parameters
accummulatedFocusTime = 0;
AttentionSpan = ang2pix(5, monitorDistance, monitorWidth / screenWidth);% it should be defined in terms of eccentricity
% *determine the reward parameter
extendedRewardTime = 0.8;
normalRewardTime = 0.3;
backGroundRewardTime = 0.05;
FoucsTimeToGetReward = 0.2;

% EyeTrackerParameters
% We should know the frame rate
NumberOfSampleDuringPresentation = 30;

SamplingTimeEyetracker = duration.presentation/NumberOfSampleDuringPresentation;
% 
% EyetrackerNumSamples = ceil((duration.presentation + duration.normal_rest)/SamplingTimeEyetracker * nTrial);
% EyetrackerSamples  = zeros(EyetrackerNumSamples,2);
CountSampleEyeTracker = 0;
% My new Flags
startFocusFlag = true;
% *Check the logic of the Code
% *set Trigger in each state change
% *Set parameters
% Create Database for Eyepositions

%Create Database for EyePositions
% NumberEyePositionsPerTriral = 2*NumberOfSampleDuringPresentation;
NumberEyePositionsPerTriral = ceil((duration.presentation + duration.normal_rest)/SamplingTimeEyetracker)-1;
for c=1:nTrial
    EyeData(c).positions = zeros(NumberEyePositionsPerTriral,2);
    EyeData(c).times = zeros(NumberEyePositionsPerTriral,1);
end    



nReward = 0;
try
    SimpleGazeTracker('StartRecording', 'Start Session', 0.1);
    
    sendtrig(sendTriggers, connectToEyeTracker, shTag, SESSION_START)
    onsetTimer = tic;
    
    pumpState = USURPING;
    iBlock = 1;
    iTrial = 1;
    while taskState ~= FINISHING && ~Params.isStopped
        % *fixationRadius should change
        fixSize = ang2pix(Params.fixationRadius, monitorDistance, monitorWidth / screenWidth);    % in pixels
        stmSize = ang2pix(Params.stimulusSize, monitorDistance, monitorWidth / screenWidth);
        stmRect = CenterRect([0, 0, stmSize, stmSize], winRect);
%         fixSize = inf;
        if connectToEyeTracker
            pos = SimpleGazeTracker('GetEyePosition', 1, 0.01);
  
            x = pos{1}(1);
            y = pos{1}(2);  
            [~, ~, buttons, ~, ~, ~] = GetMouse(winPtr);
        else
            [x, y, buttons, ~, ~, ~] = GetMouse(winPtr);
        end
        
        if buttons(2)
            sca
        end
        
        gazeLocIntact = [x, y] - floor([screenWidth, screenHeight] / 2);
        gazeLoc  = [x, y];
        gazeLoc  = gazeLoc - floor([screenWidth, screenHeight] / 2) - ...
            [Params.xOffset, Params.yOffset];
        
        % Check for Eye Fixation
        if norm(gazeLoc) < fixSize
            if ~isFixated
                isFixated = true;
                fixTimer = tic;
                rewTimer = tic;
                % Eye Tracker Recording Time Start
                eyeTrackerTimer = tic;
                sendtrig(sendTriggers, connectToEyeTracker, shTag, FIX_START)
            end
            if toc(eyeTrackerTimer)>SamplingTimeEyetracker && (taskState == PRESENTING || taskState == RESTING)
               eyeTrackerTimer = tic;
%                sendtrig(sendTriggers, connectToEyeTracker, shTag, EYE_TRIGGER)
               CountSampleEyeTracker = CountSampleEyeTracker + 1;
               if CountSampleEyeTracker<=NumberEyePositionsPerTriral
%                    EyetrackerSamples(CountSampleEyeTracker,2) = y;
%                    EyetrackerSamples(CountSampleEyeTracker,1) = x;
                     EyeData(iTrial).times(CountSampleEyeTracker,1) = toc(onsetTimer); 
                     EyeData(iTrial).positions(CountSampleEyeTracker,1) = x;
                     EyeData(iTrial).positions(CountSampleEyeTracker,2) = y; 
               end    
            end
            
        else
            isFixated = false;
        end
        
        if(toc(daqTimer) > 0.1)
            daqTimer = tic;
            fprintf(Connection1, num2str(gazeLocIntact));
        end
        
        % Check durations for automatic reward
%        if isFixated && toc(rewTimer) > Params.rewardInterval && (taskState ~= PAUSING)
 %           rewTimer = tic;
%             Params.manualReward = true;                                     % This a not the ideal notion to grant reward
%         end                                                                 % but to avoid more variable e.g. isAutoReward I used the manualReward flag.
        if Params.fillPipe
            while Params.fillPipe
                outputSingleScan(shReward, 1);
            end
            outputSingleScan(shReward, 0);
        end
        % Update Pump States
        if Params.manualReward
            Params.manualReward = false;
            pumpState = GRANTING;
            pmpTimer  = tic;
            isPumpStateChanged = true;
        end
        % this part is for reward randomly
        % This reward part is not necessary
%         if toc(pmpTimer) > Params.rewardDuration && pumpState == GRANTING
%             pumpState = USURPING;
%             isPumpStateChanged = true;
%         end
        
        % Update Task State and Trial List [if Necessary]
        switch taskState
            case IDLE
                if Params.isPaused
                    isChanged = true;
                    taskState = PAUSING;
                elseif ~Params.isPaused && isFixated && Params.isStarted
                    isChanged = true;
                    taskState = FIXATING;
                else
                    taskState = IDLE;
                end
                
            case FIXATING
                if Params.isPaused
                    isChanged = true;
                    taskState = PAUSING;
                elseif ~Params.isPaused && ~isFixated
                    isChanged = true;
                    punTimer  = tic;
                    taskState = PUNISHING;
                elseif ~Params.isPaused && isFixated && ...
                        toc(fixTimer) >= duration.fixation
                    isChanged = true;
                    stmTimer  = tic;
                    taskState = PRESENTING;
                else
                    taskState = FIXATING;
                end
                
            case PRESENTING
                if Params.isPaused
                    isChanged = true;
                    taskState = PAUSING;
                elseif ~Params.isPaused && ~isFixated
                    isChanged = true;
                    punTimer  = tic;
                    
                    trials(iTrial).onset = NaN;
                    trials = [trials, trials(iTrial)]; %#ok<AGROW>
                    trials(iTrial) = [];
                    sendtrig(sendTriggers, connectToEyeTracker, shTag, TRL_FAILURE);
                    taskState = PUNISHING;
                elseif toc(stmTimer) < duration.presentation

                    % Calculating eye distance from target dimention
                    temp = [x,y] - trials(iTrial).positionMatrix(RewardDimention,:);
                    distanaceFromRewardDimention = norm(temp);
                    % Calculating Accumulative FocusTime;
                    % *I need to determine AttentionSpan
                    if distanaceFromRewardDimention<AttentionSpan && startFocusFlag
                        startFocusFlag = false;
                        focusTimer = tic; 
                    elseif (distanaceFromRewardDimention>=AttentionSpan) && ~startFocusFlag
                        accummulatedFocusTime = accummulatedFocusTime + toc(focusTimer);
                        startFocusFlag =true;   
                    end                    
                elseif toc(stmTimer) >= duration.presentation 
                    isChanged = true;
                    rewardTimer  = tic;
                    taskState = REWARD;

                end
            case REWARD
                if Params.isPaused
                    isChanged = true;
                    taskState = PAUSING;
                elseif toc(rewardTimer) >= duration.reward
                    isChanged = true;
                    rstTimer  = tic;
                    taskState = RESTING;
                    
                    pumpState = USURPING;
                    isPumpStateChanged = true;
 
                end
                    
                  
            case RESTING
                if Params.isPaused
                    isChanged = true;
                    taskState = PAUSING;
                elseif ~Params.isPaused && (iTrial <= nTrial) && ~isFixated
                    isChanged = true;
                    punTimer = tic;
                    
                    trials(iTrial).onset = NaN;
                    trials(iTrial).stmSize = NaN;
                    trials = [trials, trials(iTrial)]; %#ok<AGROW>
                    trials(iTrial) = [];
                    sendtrig(sendTriggers, connectToEyeTracker, shTag, TRL_FAILURE);
                    taskState = PUNISHING;
                elseif ~Params.isPaused && (iTrial <= nTrial) && ...
                        isFixated && toc(rstTimer) >= duration.rest
                    isChanged = true;
                    stmTimer  = tic;
                    iTrial = iTrial + 1;
                    CountSampleEyeTracker = 0;
                    
                    fprintf(Connection2, num2str([iBlock, iTrial, nReward]));
                    
                    sendtrig(sendTriggers, connectToEyeTracker, shTag, TRL_SUCCESS);
                    
                    if (iTrial > nTrial)
                        taskState = FINISHING;
                    else
                        taskState = PRESENTING;
                    end
                end
                
            case PUNISHING
                if Params.isPaused
                    isChanged = true;
                    taskState = PAUSING;
                elseif ~Params.isPaused && toc(punTimer) >= duration.punish
                    isChanged = true;
                    taskState = IDLE;
                end
               
            case PAUSING
                if Params.isStarted
                    isChanged = true;
                    taskState = IDLE;
                else
                    taskState = PAUSING;
                end
                
            otherwise
                error('Unexpected task state!')
        end
        
        % Handle Task's Graphical Window
        if isChanged
            switch taskState
                case IDLE
%                     Screen('FillRect', winPtr, fixCrossColor, fixCross');
%                     Screen('Flip', winPtr);
                case FIXATING
%                     Screen('FillRect', winPtr, fixCrossColor, fixCross');
%                     Screen('Flip', winPtr);
                case PRESENTING
%                     trials(iTrial).stmSize = Params.stimulusSize;
%                     trials(iTrial).onset = toc(onsetTimer);
%                     Screen('DrawTexture', ...
%                         winPtr, ...
%                         stimTextures(char(trials(iTrial).name)), ...
%                         [], ...
%                         stmRect);
%                     Screen('Flip', winPtr);
                    for i= 1:size(trials(iTrial).matrix,1)
                        for j=1:size(trials(iTrial).matrix,2)
                            centerPoint_stm = centerPoint + [-R*sin(trials(iTrial).angle(i,j)),-R*cos(trials(iTrial).angle(i,j)),-R*sin(trials(iTrial).angle(i,j)),-R*cos(trials(iTrial).angle(i,j))];
                            stmRect = centerPoint_stm + [-wstimSize/2,-hstimSize/2,wstimSize/2,hstimSize/2];
                            Screen('DrawTexture', ...
                            winPtr, ...
                            stimTextures(stimNames((i-1)*4+trials(iTrial).matrix(i,j),:)), ...
                            [], ...
                            stmRect);
                        end
                    end
                    Screen('Flip', winPtr);
                    sendtrig(sendTriggers, connectToEyeTracker, shTag, STM_ONSET)
                case REWARD
                    if (rand()<trials(iTrial).RewProb)
                        Params.manualReward = true;
                        if accummulatedFocusTime>Params.FoucsTimeToGetReward
                           duration.reward = extendedRewardTime;
                        else
                           duration.reward = normalRewardTime;
                        end   
                    else 
                        Params.manualReward = true;
                        duration.reward = backGroundRewardTime;  
                    end
                        
                    %sendtrig(sendTriggers, connectToEyeTracker, shTag, trials(iTrial).index)
                    duration.rest = duration.normal_rest - duration.reward; 
                    sendtrig(sendTriggers, connectToEyeTracker, shTag, REWARD_ONSET)
                case RESTING
%                     Screen('FillRect', winPtr, fixCrossColor, fixCross');
%                     Screen('Flip', winPtr);
                    
                    % reset some parameters
                    accummulatedFocusTime = 0;
                    startFocusFlag = true;
                    sendtrig(sendTriggers, connectToEyeTracker, shTag, REWARD_OFFSET)
                    
                    
                    
                    
%                     sendtrig(sendTriggers, connectToEyeTracker, shTag, STM_OFFSET)
                case PUNISHING
                    sendtrig(sendTriggers, connectToEyeTracker, shTag, FIX_BREAK)
                    
                    
                    sendtrig(sendTriggers, connectToEyeTracker, shTag, TRL_FAILURE)
                    Screen('Flip', winPtr);
                case PAUSING
%                     Screen('FrameRect', ...
%                         winPtr, ...
%                         fixCrossColor, ...
%                         CenterRect(1.5 * normBoundsRect, winRect), ...
%                         2);
%                     Screen('DrawText', ...
%                         winPtr, ...
%                         'Paused', ...
%                         cX - floor(xAdvance / 2), ...
%                         cY + floor(normBoundsRect(4) / 2), ...
%                         fixCrossColor, ...
%                         WhiteIndex(winPtr) / 2);
                    Screen('Flip', winPtr);
            end
            isChanged = false;
        end
                
        if isPumpStateChanged
            isPumpStateChanged = false;
            switch pumpState
                case GRANTING
                    
                    nReward = nReward + 1;
                    outputSingleScan(shReward, 1)
                case USURPING
                    outputSingleScan(shReward, 0)
            end
        end
    end
   
catch ME
    disp(ME.message)
end
outputSingleScan(shReward, 0)

%%
save(fullfile(sessionDir,'\', strcat(sessionDateTime, '_TaskData.mat')), 'trials')
%My change
% Save Eyetracker Samples 
save([sessionDir,'\','EyetrackerSamples_',datestr(now,'mm-dd-yyyy_HH_MM_SS'),'.mat'],'EyeData');
Screen('CloseAll');

if connectToControllerServer
    fclose(Connection1);
    fclose(Connection2);
    
    delete(Connection1);
    delete(Connection2);
    
    clear Connection1 Connection2
end

if connectToEyeTracker
    msg = SimpleGazeTracker('GetWholeEyePositionList', 1, 1);
    save(fullfile(sessionDir,'\', strcat(sessionDateTime, '_EyePositionList.mat')), 'msg')

    msg = SimpleGazeTracker('GetWholeMessageList', 3.0);
    save(fullfile(sessionDir,'\', strcat(sessionDateTime, '_EyeMessageList.mat')), 'msg')

    SimpleGazeTracker('StopRecording','',0.1);
    SimpleGazeTracker('CloseDataFile');
    SimpleGazeTracker('CloseConnection');
end