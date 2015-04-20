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

% Specify the strings you wish to examine. These are the only strings that
% worked with the markSegments (I had to change the file names to end with
% suffix _c1. 
% '013.1', '014.1', '015.1','016.1', '017.1', '020.1', '021.1', '022.1'
% '013.2', '014.2', '015.2', '016.2', '017.2', '021.2', '022.2'
% subj_test_off = {}; 
% subj_test_on = {}; 
% subj_string = [subj_test_off, subj_test_on]; 
% subj_string = [{'021.1', '022.1', '021.2', '022.2'}];
% subj_string = [{'013.1', '014.1', '015.1','016.1', '017.1', '020.1', '021.1', '022.1', '013.2', '014.2', '015.2', '016.2', '017.2', '021.2', '022.2'}];

function postureAnalysis(subj_string)%, ~mat02)
    %% Setup is the same for all feature extractions...   
    % Load mat file and set up
    % Locations of subject .mat files generated via importSkeleton as well as 
    % the CSV files from video (assumed to be same parent directory)
    mainDir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD';
    matDir = '/01_Setup/Subj_Preprocessed_Data/'; 
    csvDir = '/04_Skeleton_Coords/Camera1_SitStand/';
    
    segmentDir = '/Users/adam2392/Desktop';
    segmentFile = fullfile(segmentDir, 'Camera1_SitStand_Segmented.csv');
    
    mat_files = fullfile(mainDir, matDir);
    csv_files = fullfile(mainDir, csvDir); 
    
    %% Generate MAT files for steps
    % loop through each subject
    for iii = 1:length(subj_string)   
        disp(subj_string{iii})  % displays current subject we are on...

        % 9 Tests per .mat file
        exp = 'SitStand';
        ranges = markSegments(csv_files, exp, subj_string{iii}, segmentFile); 
    
        % get the subject number and then load in the original mat file
        % from setup
        sub = {strrep(subj_string{iii},'.','_')}
        load_string = strcat(mat_files, 'Subj_', sub{1})
        load(load_string)
        
        % create a variable that holds the subject number/name
        eval(['placeholder_Name =' 'Subj_' sub{1} ';'])
        
        
        lengthofvars = sum(ranges(:, 2) - ranges(:, 1)) + length(ranges(:,1));
           
        % Initialize Variables
        headshoulder = []; % angle between head and shoulder_center
        shouldercenterleft = []; % angle between shoulder_center and shoulder_left 
        shouldercenterright = []; % angle between shoulder_center and shoulder_right
        shoulderspine = []; % angle between shoulder_center to spine
        spinehip = [];  % angle between spine and hip
        time_stamps = [];
        test_starts = [];
%         headshoulder = zeros(lengthofvars, 1);
%         shouldercenterleft = zeros(lengthofvars, 1);
%         shouldercenterright = zeros(lengthofvars, 1);
%         shoulderspine = zeros(lengthofvars, 1);
%         spinehip = zeros(lengthofvars, 1);
%         time_stamps = zeros(lengthofvars, 1);
        
        %loop through each range of experiment
        for jjj = 1:size(ranges, 1)
            
            %% Defining Posture 01: Find angle between all features as time series
            % convert str2double
            if(~isnumeric(placeholder_Name.SitStand.head.x(ranges(jjj, 1):ranges(jjj, 2))))
                % head-shoulder 
                headshoulderx = str2double(placeholder_Name.SitStand.head.x(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.shoulder_center.x(ranges(jjj, 1):ranges(jjj, 2)));
                headshouldery = str2double(placeholder_Name.SitStand.head.y(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.shoulder_center.y(ranges(jjj, 1):ranges(jjj, 2)));
                headshoulder = [headshoulder; ... 
                    atand(headshouldery./headshoulderx);];
                
                % shoulder_center-spine
                shoulderspinex = str2double(placeholder_Name.SitStand.shoulder_center.x(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.spine.x(ranges(jjj, 1):ranges(jjj, 2)));
                shoulderspiney = str2double(placeholder_Name.SitStand.shoulder_center.y(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.spine.y(ranges(jjj, 1):ranges(jjj, 2)));
                shoulderspine = [shoulderspine; ... 
                    atand(shoulderspiney./shoulderspinex);];
                
                % shoulder_center-left
                shouldercenterleftx = str2double(placeholder_Name.SitStand.shoulder_center.x(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.shoulder_left.x(ranges(jjj, 1):ranges(jjj, 2)));
                shouldercenterlefty = str2double(placeholder_Name.SitStand.shoulder_center.y(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.shoulder_left.y(ranges(jjj, 1):ranges(jjj, 2)));
                shouldercenterleft = [shouldercenterleft; ... 
                    atand(shouldercenterlefty./shouldercenterleftx);];
                
                % shoulder_center-right
                shouldercenterrightx = str2double(placeholder_Name.SitStand.shoulder_center.x(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.shoulder_right.x(ranges(jjj, 1):ranges(jjj, 2)));
                shouldercenterrighty = str2double(placeholder_Name.SitStand.shoulder_center.y(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.shoulder_right.y(ranges(jjj, 1):ranges(jjj, 2)));
                shouldercenterright = [shouldercenterright; ... 
                    atand(shouldercenterrighty./shouldercenterrightx);];
                
                % spine-hip
                spinehipx = str2double(placeholder_Name.SitStand.spine.x(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.hip_center.x(ranges(jjj, 1):ranges(jjj, 2)));
                spinehipy = str2double(placeholder_Name.SitStand.spine.y(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                    str2double(placeholder_Name.SitStand.hip_center.y(ranges(jjj, 1):ranges(jjj, 2)));
                spinehip = [spinehip; ... 
                    atand(spinehipy./spinehipx);];
                
            % carry out just regular calc. w/o str2double
            else   
                % head-shoulder 
                headshoulderx = placeholder_Name.SitStand.head.x(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.shoulder_center.x(ranges(jjj, 1):ranges(jjj, 2));
                headshouldery = placeholder_Name.SitStand.head.y(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.shoulder_center.y(ranges(jjj, 1):ranges(jjj, 2));
                headshoulder = [headshoulder; ... 
                    atand(headshouldery./headshoulderx);];
                
                % shoulder_center-spine
                shoulderspinex = placeholder_Name.SitStand.shoulder_center.x(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.spine.x(ranges(jjj, 1):ranges(jjj, 2));
                shoulderspiney = placeholder_Name.SitStand.shoulder_center.y(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.spine.y(ranges(jjj, 1):ranges(jjj, 2));
                shoulderspine = [shoulderspine; ... 
                    atand(shoulderspiney./shoulderspinex);];
                
                % shoulder_center-left
                shouldercenterleftx = placeholder_Name.SitStand.shoulder_center.x(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.shoulder_left.x(ranges(jjj, 1):ranges(jjj, 2));
                shouldercenterlefty = placeholder_Name.SitStand.shoulder_center.y(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.shoulder_left.y(ranges(jjj, 1):ranges(jjj, 2));
                shouldercenterleft = [shouldercenterleft; ... 
                    atand(shouldercenterlefty./shouldercenterleftx);];
                
                % shoulder_center-right
                shouldercenterrightx = placeholder_Name.SitStand.shoulder_center.x(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.shoulder_right.x(ranges(jjj, 1):ranges(jjj, 2));
                shouldercenterrighty = placeholder_Name.SitStand.shoulder_center.y(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.shoulder_right.y(ranges(jjj, 1):ranges(jjj, 2));
                shouldercenterright = [shouldercenterright; ... 
                    atand(shouldercenterrighty./shouldercenterrightx);];
                
                % spine-hip
                spinehipx = placeholder_Name.SitStand.spine.x(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.hip_center.x(ranges(jjj, 1):ranges(jjj, 2));
                spinehipy = placeholder_Name.SitStand.spine.y(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                    placeholder_Name.SitStand.hip_center.y(ranges(jjj, 1):ranges(jjj, 2));
                spinehip = [spinehip; ... 
                    atand(spinehipy./spinehipx);];
            end
            
            test_starts = [test_starts, length(spinehip)];
            
            %% Store the time stamps in variable list also -> plot time vs. step
            time = placeholder_Name.SitStand.time_stamp(ranges(jjj,1):ranges(jjj,2));

            for t=1:length(time)
                %split up the timestamp into its 3 components and then 
                %correct time stamps, if they dont' have enough integers
                csvtimeSplit = regexp(time{t}, '\:', 'split');

                % if it is a newer file, where timestamps are separated by _
                % instead of :
                if(length(csvtimeSplit) == 1)
                    csvtimeSplit = regexp(time{t}, '\_', 'split');
                end

                %check if we found the time stamp that is close to the first frame
                %convert to milliseconds
                minutes = 60000*str2double(csvtimeSplit{1});
                seconds = 1000*str2double(csvtimeSplit{2});
                milliseconds = str2double(csvtimeSplit{3});
                total = minutes+seconds+milliseconds;

                time_stamps = [time_stamps, total];
            end
        end
        
        %% Run Moving Average Filter
        filter_window = 10;
        %... insert code
        
        %% Save for Mat File Output
        Subj_Name.headshoulder = headshoulder;
        Subj_Name.shouldercenterleft = shouldercenterleft;
        Subj_Name.shouldercenterright = shouldercenterright;
        Subj_Name.shoulderspine = shoulderspine;
        Subj_Name.spinehip = spinehip;
        Subj_Name.timestamps = time_stamps;
        Subj_Name.segments = test_starts;
        
        featurename = 'Posture'; % Change correspondingly (e.g. 'Step', 'Posture', etc.)
        featuredir = strcat('Processed_', featurename);
        
        eval(['Subj_' sub{1} '_' featurename '= Subj_Name;'])
        
        if (exist(featuredir,'dir') ~= 7)
            mkdir(featuredir)
        end
        
        % Save folder as /Processed_Posture/Subj_020.1_Posture.mat
        save(['./Processed_' featurename '/Subj_' sub{1} '_' featurename],['Subj_' sub{1} '_' featurename])
    end
    
    clearvars -except Subj_*_Posture
    
    %% Plotting Time Series  
    % Plot figure, with red lines at the end of each experiment
    subjNum = '021.1';
    fig = figure;
    hold on
    titleplot1 = strcat('Graph of Angle Head-shouldercenter vs. Time of', ' ', subjNum);
    titleplot2 = strcat('Graph of Angle shouldercenter-shoulderleft vs. Time of', ' ', subjNum);
    titleplot3 = strcat('Graph of Angle shouldercenter-shoulderright vs. Time of', ' ', subjNum);
    titleplot4 = strcat('Graph of Angle spine-hip vs. Time of', ' ', subjNum);
   
    %plot angle between head/shoulder
    subplot(2, 2, 1)
    plot(Subj_021_1_Posture.timestamps, Subj_021_1_Posture.headshoulder)
    title(titleplot1)
    xlabel('time')
    ylabel('Angle (degrees)')
    
    %plot angle between shoulder/left
    subplot(2, 2, 2)
    plot(Subj_021_1_Posture.timestamps, Subj_021_1_Posture.shouldercenterleft)
    title(titleplot2)
    xlabel('time')
    ylabel('Angle (degrees)')
    
    %plot angle between shoulder/right
    subplot(2, 2, 3)
    plot(Subj_021_1_Posture.timestamps, Subj_021_1_Posture.shouldercenterright)
    title(titleplot3)
    xlabel('time')
    ylabel('Angle (degrees)')
    
    %plot angle between spine/hip
    subplot(2, 2, 4)
    plot(Subj_021_1_Posture.timestamps, Subj_021_1_Posture.spinehip)
    title(titleplot4)
    xlabel('time')
    ylabel('Angle (degrees)')
    
    % Add segment marks for each plot
    for j = 1:4
        subplot(2, 2, j)
        yl = ylim;
        for k=1:length(Subj_021_1_Posture.segments)
            segment = Subj_021_1_Posture.segments(k);
            SP = Subj_021_1_Posture.timestamps(segment);
            line([SP SP], [yl(1) yl(2)], 'Color',[1 0 0])
        end
    end
end % end of function    