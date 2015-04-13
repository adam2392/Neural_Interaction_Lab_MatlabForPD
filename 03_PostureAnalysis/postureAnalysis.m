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

function postureAnalysis(mat01, subjNum)%, ~mat02)
    %% Load mat file and set up
    % load subject mat file and set up
    subject = load(mat01);
    index = strfind(mat01, '.mat');
    name = mat01(1:index-1);
    
    % Change function call accordingly
    
    fileWithImages = '/Users/adam2392/Desktop/Analysis Folder';%'/Volumes/NIL_PASS/Camera1/020.1_October28/020.1_Color_Walk';
    exp = 'Walk';
%     subjNum = '021.1';
    %%% analysisIndices = the start/end indices to analyze 
    analysisIndices = markSegments(fileWithImages, exp, subjNum);
    
    %% Defining Posture 01: Find angle between head-shoulder_center-spine as time series
    %absolute value?
    %first column
    startRange = analysisIndices(:, 1);
    endRange = analysisIndices(:, 2);
    totalRange = endRange - startRange;
    
    totalAngle = [];
    expSections = [];
    time = [];
    for i=1:length(startRange)
        
        % The case where the imported csv data is strings instead of ints do conversion...
%         if(~isnumeric(subject.(name).Walk.head.x))
%             % get all the joint names
%             joints = fieldnames(subject.(name).Walk);
%             
%             for j=1:length(joints)
%                 joint = char(joints(i))
%                 subject.(name).Walk.(joint).x = str2double(subject.(name).Walk.(joint).x);
%                 subject.(name).Walk.(joint).y = str2double(subject.(name).Walk.(joint).y);
%                 subject.(name).Walk.(joint).z = str2double(subject.(name).Walk.(joint).z);
%             end
%             
%             subject.(name).Walk.head.x(1:2)
%         end
%         str2double(subject.(name).Walk.head.x(startRange(i):endRange(i)))
        
        if (~isnumeric(subject.(name).Walk.head.x))
            dist01x = str2double(subject.(name).Walk.head.x(startRange(i):endRange(i))) - str2double(subject.(name).Walk.shoulder_center.x(startRange(i):endRange(i)));
            dist01y = str2double(subject.(name).Walk.head.y(startRange(i):endRange(i))) - str2double(subject.(name).Walk.shoulder_center.y(startRange(i):endRange(i)));
            dist02x = str2double(subject.(name).Walk.shoulder_center.x(startRange(i):endRange(i))) - str2double(subject.(name).Walk.spine.x(startRange(i):endRange(i)));
            dist02y = str2double(subject.(name).Walk.shoulder_center.y(startRange(i):endRange(i))) - str2double(subject.(name).Walk.spine.y(startRange(i):endRange(i)));
        else
            % head to shoulder_center distance/angle
            dist01x = subject.(name).Walk.head.x(startRange(i):endRange(i)) - subject.(name).Walk.shoulder_center.x(startRange(i):endRange(i));
            dist01y = subject.(name).Walk.head.y(startRange(i):endRange(i)) - subject.(name).Walk.shoulder_center.y(startRange(i):endRange(i));
            
            % shoulder_center to spine distance/angle
            dist02x = subject.(name).Walk.shoulder_center.x(startRange(i):endRange(i)) - subject.(name).Walk.spine.x(startRange(i):endRange(i));
            dist02y = subject.(name).Walk.shoulder_center.y(startRange(i):endRange(i)) - subject.(name).Walk.spine.y(startRange(i):endRange(i));  
        end   
        length01 = (dist01x.^2 + dist01y.^2).^0.5;
        angle01 = atand(dist01y./dist01x);

        length02 = (dist02x.^2 + dist02y.^2).^0.5;
        angle02 = atand(dist02y./dist02x);
%         total = 180 - abs(angle01+angle02);
        total = abs(angle01+angle02);

        totalAngle = [totalAngle, transpose(total)];
        
        expSections(i) = length(totalAngle);
    end

    %% Plotting Time Series
    
    % Plot figure, with red lines at the end of each experiment
    fig = figure;
    hax = axes;
    hold on
    plot(totalAngle)
    titleplot = strcat('Graph of Angle Head-Spine vs. Time of', ' ', subjNum);
    title(titleplot)
    xlabel('time')
    ylabel('Angle (degrees) from head to spine')
    for i=1:length(expSections)
        SP = expSections(i);
        line([SP SP], [200 0], 'Color',[1 0 0])
    end
    
    %% Convert to mat file and saving   
    % save - totalAngle, 
    Subj_Name.totalAngle = totalAngle;
    Subj_Name.timeMarks = expSections;
    %Subj_Name.

    sub = strrep(subjNum,'.','_');
    % takes subject name and renames it with the subject number
    eval(['Subj_' sub '_Posture' '= Subj_Name;'])

    %Creates a folder 
    if (exist('Processed_Posture','dir') ~= 7)
        mkdir('Processed_Posture')
    end

    save(['./Processed_Posture/Subj_' sub '_Posture'],['Subj_' sub '_Posture'])
end
    