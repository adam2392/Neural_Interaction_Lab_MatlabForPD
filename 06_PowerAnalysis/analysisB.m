clear all; close all; clc;

%% Set up of all subjects, we want to go through
subj_test_off = {'120', '119', '121', '117', '118','013.1', '014.1', '015.1','016.1', '017.1', '020.1', '021.1', '022.1', '113'};%,'115'}; 
subj_test_on = {};%'013.2', '014.2', '015.2', '016.2', '017.2', '021.2', '022.2'}; 
subj_string = [subj_test_off, subj_test_on]; 

% Locations of subject .mat files generated via importSkeleton as well as
% the CSV files from video (assumed to be same parent directory)
mainDir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD';
matDir = '/01_Setup/Subj_Preprocessed_Data/Camera1/';
walkDir = '/02_StepAnalysis/Processed_StepLength/';
csvDir = '/04_Skeleton_Coords/Camera1_Walk/'; 

segmentDir = '/Users/adam2392/Desktop';
segmentFile = fullfile(segmentDir, 'Camera1_Walk_Segmented.csv');

mat_files = fullfile(mainDir, matDir);
walk_files = fullfile(mainDir, walkDir);
csv_files = fullfile(mainDir, csvDir); 

% loop through each subject and perform spectemp analysis...
for iii = 1:length(subj_string)
    % get the subject name replacing '.' with '_'
    sub = {strrep(subj_string{iii},'.','_')}
    
    load_string = strcat(walk_files, 'Subj_', sub{1}, '_Step')
    load(load_string)
    
    eval(['placeholder_Name =' 'Subj_' sub{1} '_Step' ';'])
    
    [deltaUniform, fs] = fixSampling(load_string, sub{1});
    
%     load Parkinsons_Data/From_Adam/Subj_022_1_fixed.mat

%     fs=30 %WHAT SHOULD THIS BE? change within fixsampling
    
    % Spectrotemporal Pursuit Algorithm
    % Analysis on Power?
    alpha = 50;             % *** CAN set to different values
    window = fs*5;          % *** How big the window of analysis is?

    % use specPursuit.m to perform robust spectrotemporal decomposition
    [xEst,freq,tWin,iter] = specPursuit(deltaUniform,fs,window,alpha);

    figure; imagesc(tWin,freq,20*log10(abs(xEst)));axis xy;colorbar;
    
    ylabel('Frequency (Hz)');xlabel('Time (s)');
    colorbar;colormap jet;ylim([0.2 2]);caxis([-40 -20]);
    Power=20*log10(abs(xEst));
    
    Subj_Name.Power = Power;
    Subj_Name.freq = freq;
    Subj_Name.time = tWin;
    
    eval(['Subj_' sub{1} '_fixed_a' num2str(alpha) '_Power' '= Subj_Name;'])
    
    if (exist('Processed_Spec','dir') ~= 7)
        mkdir('Processed_Spec')
    end
    
    % Save the power spectrum to analyze quantitatively
%     powerFile = strcat('./Processed_Spec/Subj_', sub{1}, '_fixed_a', num2str(alpha), '_Power');
%     save(powerFile, 'Power');
    
    save(['./Processed_Spec/Subj_' sub{1} '_fixed_a' num2str(alpha) '_Power'],['Subj_'  sub{1} '_fixed_a' num2str(alpha) '_Power'])
        
    
    % Save the spectrogram image
    imageName = strcat('/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/PowerAnalysis', '/Processed_Spec/Subj_', sub{1}, '_RobustSpec_a' , num2str(alpha)); % c4020
    saveas(gcf, imageName, 'png')
    
    close all;
end