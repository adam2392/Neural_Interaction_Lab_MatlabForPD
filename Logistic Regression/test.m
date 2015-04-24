% Load all the data and run get_performance.m

off_13 = load('subjects/subj_013_1_Step.mat');
on_13  = load('subjects/subj_013_2_Step.mat');
off_14 = load('subjects/subj_014_1_Step.mat');
on_14  = load('subjects/subj_014_2_Step.mat');
off_15 = load('subjects/subj_015_1_Step.mat');
on_15  = load('subjects/subj_015_2_Step.mat');
off_17 = load('subjects/subj_017_1_Step.mat');
on_17  = load('subjects/subj_017_2_Step.mat');
off_21 = load('subjects/subj_021_1_Step.mat');
on_21  = load('subjects/subj_021_2_Step.mat');
off_22 = load('subjects/subj_022_1_Step.mat');
on_22  = load('subjects/subj_022_2_Step.mat');

R = zeros(3,13);
y = [ 0;1;0;1;0;1;0;1;0;1;0;1 ];

R(1,1) = off_13.Subj_013_1_Step.amplitude;
R(1,2) = off_13.Subj_013_1_Step.variance;
R(1,3) = off_13.Subj_013_1_Step.frequency;

R(2,1) = on_13.Subj_013_2_Step.amplitude;
R(2,2) = on_13.Subj_013_2_Step.variance;
R(2,3) = on_13.Subj_013_2_Step.frequency;

R(3,1) = off_14.Subj_014_1_Step.amplitude;
R(3,2) = off_14.Subj_014_1_Step.variance;
R(3,3) = off_14.Subj_014_1_Step.frequency;

R(4,1) = on_14.Subj_014_2_Step.amplitude;
R(4,2) = on_14.Subj_014_2_Step.variance;
R(4,3) = on_14.Subj_014_2_Step.frequency;

R(5,1) = off_15.Subj_015_1_Step.amplitude;
R(5,2) = off_15.Subj_015_1_Step.variance;
R(5,3) = off_15.Subj_015_1_Step.frequency;

R(6,1) = on_15.Subj_015_2_Step.amplitude;
R(6,2) = on_15.Subj_015_2_Step.variance;
R(6,3) = on_15.Subj_015_2_Step.frequency;

R(7,1) = off_17.Subj_017_1_Step.amplitude;
R(7,2) = off_17.Subj_017_1_Step.variance;
R(7,3) = off_17.Subj_017_1_Step.frequency;

R(8,1) = on_17.Subj_017_2_Step.amplitude;
R(8,2) = on_17.Subj_017_2_Step.variance;
R(8,3) = on_17.Subj_017_2_Step.frequency;

R(9,1) = off_21.Subj_021_1_Step.amplitude;
R(9,2) = off_21.Subj_021_1_Step.variance;
R(9,3) = off_21.Subj_021_1_Step.frequency;

R(10,1) = on_21.Subj_021_2_Step.amplitude;
R(10,2) = on_21.Subj_021_2_Step.variance;
R(10,3) = on_21.Subj_021_2_Step.frequency;

R(11,1) = off_22.Subj_022_1_Step.amplitude;
R(11,2) = off_22.Subj_022_1_Step.variance;
R(11,3) = off_22.Subj_022_1_Step.frequency;

R(12,1) = on_22.Subj_022_2_Step.amplitude;
R(12,2) = on_22.Subj_022_2_Step.variance;
R(12,3) = on_22.Subj_022_2_Step.frequency;

get_performance(R,y)