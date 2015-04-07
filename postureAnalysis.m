%Function written by Adam Li on 02/09/15
%Input: - 
%
%Output: - Analyze posture as time series
%
% To run:
% postureAnalysis('Subj_020_2.mat')
% ***Assumes that all csv files are segmented by subject id...
%
%Description: Takes all the segmented files and inserts marks in skeletal
%data csv file to determine which ranges of time series to analyze.

function postureAnalysis(mat01)%, ~mat02)
    %% Load mat file and set up
    % load subject mat file and set up
    subject = load(mat01)
    index = strfind(mat01, '.mat')
    name = mat01(1:index-1)
    
    %% Defining Posture 01: Find angle between head-shoulder_center-spine as time series
    
    % absolute value?
    % head to shoulder_center distance/angle
    dist01x = subject.(name).Walk.head.x - subject.(name).Walk.shoulder_center.x;
    dist01y = subject.(name).Walk.head.y - subject.(name).Walk.shoulder_center.y;
    length01 = (dist01x.^2 + dist01y.^2).^0.5;
    angle01 = atand(dist01y./dist01x);
    
    % shoulder_center to spine distance/angle
    dist02x = subject.(name).Walk.shoulder_center.x - subject.(name).Walk.spine.x;
    dist02y = subject.(name).Walk.shoulder_center.y - subject.(name).Walk.spine.y;
    length02 = (dist02x.^2 + dist02y.^2).^0.5;
    angle02 = atand(dist02y./dist02x);
    
    % calculate total angle between head to spine
    totalAngle = angle01+angle02;
    length(angle01)
    length(angle02)
    plot(totalAngle);
end
    