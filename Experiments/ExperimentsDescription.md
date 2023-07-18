Experiment 1

Status: Not Done

It is pilot recording

Experiment setup:
The task has a sequential structure which means a set of stimuli is represented in a sequence. The task is passive which means there is no need for monkey to make any action.

Presentation time = 3s, see "duration.presentation" variable
Rest time = 1s, see "duration.normal_rest" variable
BackgroundReward = 0.05s which is equal with one drop of juice, see "BackGroundRewardTime" variable
Normal Reward time = 0.3s which is equal with six drops of juice, see "normalRewardTime" variable This is the reward associated with the specific feature.
Extended Reward time = 0.8s which is equal with 15 drops of juice, see "extendedRewardTime" variable variable This is the reward associated with specific feature and given to the monkey if it looks at the specific feature for the duration of the "FoucsTimeToGetReward" which is set to 0.2s.

You can see the visualization the pipeline in the following link
https://www.tldraw.com/s/v2_c_m5Rr-UWWfF-fA5nmsU0ZI?viewport=0%2C0%2C1536%2C696&page=page%3Aj3HbFsxbRxQPinK1Enr19

It has two sessions
In the first session, Fixiation is not checked.

In the second session, Fixiation is checked and the monkey can only complete about 60 trials

To see which feature is associated with the reward, you can check "RewardDimention" and "RewardFeature". "RewardDimention" tells that which dimension has reward and "RewardFeature" tells that in that dimension which feature is associated with the reward.

Here, we have 3 dimensions saved in "dimension_number" and 4 features for each dimension saved in the "feature_number".

Experiment 2 (*)

Status: Not Done

It is pilot recording

Experiment setup:

The general setup is the same as the previous experiment. However, the way we gather eye positions is changed. This time, we don't record the eye position for each trial but we just record an array of eye position during the task with time tag started from the commencement of the session, SESSION_START trigger tag.

Presentation time = 1.5s, see "duration.presentation" variable
Rest time = 1s, see "duration.normal_rest" variable
BackgroundReward = 0.05s which is equal with one drop of juice, see "BackGroundRewardTime" variable
Normal Reward time = 0.4s which is equal with six drops of juice, see "normalRewardTime" variable This is the reward associated with the specific feature.
Extended Reward time = 0.8s which is equal with 15 drops of juice, see "extendedRewardTime" variable variable This is the reward associated with specific feature and given to the monkey if it looks at the specific feature for the duration of the "FoucsTimeToGetReward" which is 0.2

The bug of focus time is fixed. The problem is that after the finishing of the presentation we should check if it is focused 
the accumulated time is calculated.

You can see the visualization the pipeline in the following link
https://www.tldraw.com/s/v2_c_m5Rr-UWWfF-fA5nmsU0ZI?viewport=0%2C0%2C1536%2C696&page=page%3Aj3HbFsxbRxQPinK1Enr19


[] Eye Clabiration
[] Tell Meysam to change stimulus size visual angluar size to (5*5),  set in gui 
[] Check Storage of Eye Data 
Eye Data is array of N*3 the third columne should be an increasing sequence of numbering indicating the time of the recorded eye data. The first two columen is about the x and y
[] Check trigger in dac Computer, tell meysam to do so.
[] Run the experiment for Human for just several trial such as 30 or 40 and try to identify the rewarded stimulus
[] Execute on monkey
[] Check the storage of Data 
[] Save Workspace and move it to our PC.
[] Bring the edited codes if there is 



Experiment 3

Status: Not Done

It is pilot recording

Experiment setup:

The general setup is the same as the previous experiment. However, The fixation check is removed and fixation duration is set to 0.0. The protocol for data eye gathering is the same as previous one

Presentation time = 1.5s, see "duration.presentation" variable
Rest time = 1s, see "duration.normal_rest" variable
BackgroundReward = 0.05s which is equal with one drop of juice, see "BackGroundRewardTime" variable
Normal Reward time = 0.4s which is equal with six drops of juice, see "normalRewardTime" variable This is the reward associated with the specific feature.
Extended Reward time = 0.8s which is equal with 15 drops of juice, see "extendedRewardTime" variable variable This is the reward associated with specific feature and given to the monkey if it looks at the specific feature for the duration of the "FoucsTimeToGetReward" which is 0.2





You can see the general pipline of the project in the following link
https://www.tldraw.com/r/0MmaT8_6u4hHzUSb-swml?viewport=-133%2C-44%2C1536%2C687&page=page%3AHaU1BtgxyzGInHAlGNcM1

Execution Steps

[] Eye Clabiration
[] Tell Meysam to change stimulus size visual angluar size to (5*5),  set in gui 
[] Check Storage of Eye Data 
Eye Data is array of N*3 the third columne should be an increasing sequence of numbering indicating the time of the recorded eye data. The first two columen is about the x and y
[] Check trigger in dac Computer, tell meysam to do so.
[] Run the experiment for Human for just several trial such as 30 or 40 and try to identify the rewarded stimulus
[] Execute on monkey
[] Check the storage of Data 
[] Save Workspace and move it to our PC.
[] Bring the edited codes if there is 

Here, we should talk about the experiment setups at the excution time:




Experiment 4:

This experiment is about association of reward to a stimulus. 
Here, we have two stimuli which is the tag tone audio one is 440 Hz and the other is 660 Hz.
The 440 Hz(Target audio) is associate with the reward

It has threes session with the time distance of 1 min

The first and third session has no reward and the middle session has association with reward

The probabibility distribution of presenation is 0.5 for target and 0.5 for non target stimulation

You can see the visualization the pipeline in the following link
https://www.tldraw.com/r/Ug7hDGZbbcjr_bjE-BdDk?viewport=0%2C0%2C1536%2C687&page=page%3AlfPxcK5DGSdgiBL3LS-Jp

Execution Steps

[] Check trigger in dac Computer, tell meysam to do so.
[] Check if reward pump and reward trigger work. 
[] Run the task on monkey
[] check the storage of the stimulation after the end of experiment
[] Save the workspace
[] Bring the edited codes if there is 


Experiment 5


