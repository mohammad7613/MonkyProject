Experiment 1

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

Experiment 2

It is pilot recording

Experiment setup:

The general setup is the same as the previous experiment. However, the way we gather eye positions is changed. This time, we don't record the eye position for each trial but we just record an array of eye position during the task with time tag started from the commencement of the session, SESSION_START trigger tag.

Presentation time = 1.5s, see "duration.presentation" variable
Rest time = 1s, see "duration.normal_rest" variable
BackgroundReward = 0.05s which is equal with one drop of juice, see "BackGroundRewardTime" variable
Normal Reward time = 0.4s which is equal with six drops of juice, see "normalRewardTime" variable This is the reward associated with the specific feature.
Extended Reward time = 0.8s which is equal with 15 drops of juice, see "extendedRewardTime" variable variable This is the reward associated with specific feature and given to the monkey if it looks at the specific feature for the duration of the "FoucsTimeToGetReward" which is 0.2
