%% Script Written by Gabe Schamberg to generate statistical results and boxplots
% 
% Before running this script, run stepAnalytics_test_Neil.m to generate
% the structs containing the data for each subject
close all;
clear all;

%% Setup
% Base directory (user specific)
mainDir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/';
% Directory containing subject information (should not depend on user)
kinectDir = '/02_StepAnalysis/Processed_StepLength/';
% Directory containing EPARC data
eparcDir = '/05_Eparc/Processed_Eparc/';
% Load heights for normalizing EPARC data
heights = load(cat(2,mainDir,'/02_StepAnalysis/subject_heights.mat'));

%% Subject Strings
% Strings to identify the subjects we wish to consider organized by type
off_str = {'012.1','013.1','014.1','015.1','016.1','017.1',...
    '020.1','021.1','022.1'};
on_str = {'001','002','003','005','006','007','008','009','010','019'};
on_pair_str = {'012.2','013.2','014.2','015.2','016.2','017.2',...
    '020.2','021.2','022.2'};
control_str = {'103','104','105','106','107','108','109','110','112','113','114',...
    '115','117','118','119','120','121'};

%% List Description
% Initialize lists grouped data of the following format:
% type_xy(p)(hn)
% where 
%    type is one of step/cadence/velocity etc. (just step for now  
%    x = k -> kinect, x = e -> eparc
%    y = 1 -> off med, y = 2 -> on med, y = c -> control
%    p present -> p is a subset of 2 with just the patients that have an
%                 off med trial as well (i.e. step_2 is all on med and
%                 step_2p is just the on med patients with off trial)
%    hn present -> data is height normalized

%% Kinect data sets
step_k1 = zeros(length(off_str),1);
step_k1hn = zeros(length(off_str),1);
step_k2 = zeros(length(on_str)+length(on_pair_str),1);
step_k2hn = zeros(length(on_str)+length(on_pair_str),1);
step_k2p = zeros(length(on_pair_str),1);
step_k2phn = zeros(length(on_pair_str),1);
step_kc = zeros(length(control_str),1);
step_kchn = zeros(length(control_str),1);

% Populate k1 lists
for i = 1:length(off_str)
    % Load the off med struct of form: Subj_xxx_1_Step
    cur_str = off_str{i};
    num = cur_str(1:3);
    subj = load(cat(2,mainDir,kinectDir,'Subj_',num,'_1_Step'));
    subj = subj.(cat(2,'Subj_',num,'_1_Step'));
    % set values
    step_k1(i) = subj.amplitude;
%     step_k1hn(i) = subj.hnAmplitude;
end

% Populate k2 lists
for i = 1:length(on_str)
    % Load the off med struct of form: Subj_xxx_Step
    cur_str = on_str{i};
    num = cur_str(1:3);
    subj = load(cat(2,mainDir,kinectDir,'Subj_',num,'_Step'));
    subj = subj.(cat(2,'Subj_',num,'_Step'));
    % set values
    step_k2(i) = subj.amplitude;
%     step_k2hn(i) = subj.hnAmplitude;
end

% Populate k2p and rest of k2 lists
for i = 1:length(on_pair_str)
    % Load the off med struct of form: Subj_xxx_2_Step
    cur_str = on_pair_str{i};
    num = cur_str(1:3);
    subj = load(cat(2,mainDir,kinectDir,'Subj_',num,'_2_Step'));
    subj = subj.(cat(2,'Subj_',num,'_2_Step'));
    % set values
    step_k2(length(on_str)+i) = subj.amplitude;
%     step_k2hn(length(on_str)+i) = subj.hnAmplitude;
    step_k2p(i) = subj.amplitude;
%     step_k2phn(i) = subj.hnAmplitude;
end

% Populate control lists
for i = 1:length(control_str)
    % Load the off med struct of form: Subj_xxx_Step
    cur_str = control_str{i};
    num = cur_str(1:3);
    subj = load(cat(2,mainDir,kinectDir,'Subj_',num,'_Step'));
    subj = subj.(cat(2,'Subj_',num,'_Step'));
    % set values
    step_kc(i) = subj.amplitude;
%     step_kchn(i) = subj.hnAmplitude;
end

%% EPARC data sets
step_e1 = zeros(length(off_str),1);
step_e1hn = zeros(length(off_str),1);
step_e2 = zeros(length(on_str)+length(on_pair_str),1);
step_e2hn = zeros(length(on_str)+length(on_pair_str),1);
step_e2p = zeros(length(on_pair_str),1);
step_e2phn = zeros(length(on_pair_str),1);
step_ec = zeros(length(control_str),1);
step_echn = zeros(length(control_str),1);

% Populate e1 lists
for i = 1:length(off_str)
    % Load the off med struct of form: Subj_xxx_1_Step
    cur_str = off_str{i};
    num = cur_str(1:3);
    subj = load(cat(2,mainDir,eparcDir,'Subj_',num,'_EPARC'));
    subj = subj.(cat(2,'Subj_',num,'_EPARC'));
    % set values
    step_e1(i) = nanmean(subj.StepLength./200);
    height = heights.heights.(cat(2,'s',num));
    step_e1hn(i) = step_e1(i)/height;
end

% Populate e2 lists
for i = 1:length(on_str)
    % Load the off med struct of form: Subj_xxx_Step
    cur_str = on_str{i};
    num = cur_str(1:3);
    subj = load(cat(2,mainDir,eparcDir,'Subj_',num,'_EPARC'));
    subj = subj.(cat(2,'Subj_',num,'_EPARC'));
    % set values
    l = length(subj.StepLength);
    step_e2(i) = nanmean(subj.StepLength(1:l/2)./200);
    height = heights.heights.(cat(2,'s',num));
    step_e2hn(i) = step_e2(i)/height;
end

% Populate k2p and rest of k2 lists
for i = 1:length(on_pair_str)
    % Load the off med struct of form: Subj_xxx_2_Step
    cur_str = on_pair_str{i};
    num = cur_str(1:3);
    subj = load(cat(2,mainDir,eparcDir,'Subj_',num,'_EPARC'));
    subj = subj.(cat(2,'Subj_',num,'_EPARC'));
    % set values
    l = length(subj.StepLength);
    step_e2(length(on_str)+i) = nanmean(subj.StepLength(l/2:end)./200);
    height = heights.heights.(cat(2,'s',num));
    step_e2hn(length(on_str)+i) = step_e2(length(on_str)+i)/height;
    step_e2p(i) = nanmean(subj.StepLength(l/2:end)./200);
    step_e2phn(i) = step_e2p(i)/height;
end

% Populate control lists
for i = 1:length(control_str)
    % Load the off med struct of form: Subj_xxx_Step
    cur_str = control_str{i};
    num = cur_str(1:3);
    subj = load(cat(2,mainDir,eparcDir,'Subj_',num,'_EPARC'));
    subj = subj.(cat(2,'Subj_',num,'_EPARC'));
    % set values
    step_ec(i) = nanmean(subj.StepLength./200);
    height = heights.heights.(cat(2,'s',num));
    step_echn(i) = step_ec(i)/height;
end

%% T Tests
% p values for the three kinect pairings
[~,p_k1_k2] = ttest2(step_k1,step_k2p);   % no need to height normalize
[~,p_k1_kc] = ttest2(step_k1hn,step_kchn);  % different people - height normalized
[~,p_k2_kc] = ttest2(step_k2hn,step_kchn);  % different people - height normalized

% p values for the three eparc pairings
[~,p_e1_e2] = ttest2(step_e1,step_e2p);   % no need to height normalize
[~,p_e1_ec] = ttest2(step_e1hn,step_echn);  % different people - height normalized
[~,p_e2_ec] = ttest2(step_e2hn,step_echn);  % different people - height normalized

% p values for eparc vs kinect (no need for height normalization)
[~,p_k1_e1] = ttest2(step_k1,step_e1);
[~,p_k2_e2] = ttest2(step_k2,step_e2);
[~,p_kc_ec] = ttest2(step_kc,step_ec);

%% boxplots

% Comparisons of kinect and eparc
figure();
subplot(1,3,1);
boxplot([step_k1,step_e1],...
    'labels',{'Kinect','EPARC'});
title('Step Length Data for Off Med Patients');
ylim([0.1 0.5]);
ylabel('Meters');
subplot(1,3,2);
boxplot([step_k2,step_e2],...
    'labels',{'Kinect','EPARC'});
title('Step Length Data for On Med Patients');
ylim([0.1 0.5]);
subplot(1,3,3);
boxplot([step_kc,step_ec],...
    'labels',{'Kinect','EPARC'});
title('Step Length Data for Controls');
ylim([0.1 0.5]);