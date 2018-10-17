%% Script written by Neil Gandhi, modified by Madhu Krishnan, Adam Li
% Neural Interaction Lab @ UCSD
%
% To run:
% 1. modify the directories mainDir, matDir and csvDir to their 
% appropriate directories. 
% Right now, it's assumed that matDir and csvDir are in the same parent directory. 
%
% 2. Modify the subject strings you wish to examine (subj_string). This script will output
% the step .mat files into a folder mainDir called ProcessedStepLength.
% Hence, you only need to run this script once. 
%
% Dependencies:
%   - findpeaksProminent.m
%   - markSegments.m *Only if you need this... Contact Adam for reference*
%
% Notes:
% At the bottom of this file is a small plotting cell which can be useful
% if you wish to visualize the data and their peaks. 

%% 01: Loading Subjects From Directories

% Specify the subjects you wish to examine. 
 subj_string = {'001','002','003','005','006','007','008','009','010','011.1','011.2',...
     '012.1','012.2','013.1','013.2','014.1','014.2','015.1','015.2','016.1',...
     '016.2','017.1','017.2','018','019','020.1','020.2','021.1','021.2','022.1','022.2',...
     '103','104','105','106','107','108','109','110','112','113','114',...
     '115','117','118','119','120','121'};
% subj_string = {'119', '120', '121'};

%subj_string = {'013.1','013.2','014.1','014.2','015.1','015.2','022.2'};

addpath('/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/01_Setup/Subj_Preprocessed_Data/Camera1')


% Locations of subject .mat files generated via 01:importSkeleton as well as
% the CSV files from video (assumed to be same parent directory)
mainDir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD';
matDir = '/01_Setup/Subj_Preprocessed_Data/Camera1/';

expName = 'Walk';   % the experiment we want to look at

% the full dir path of the mat files
mat_files = fullfile(mainDir, matDir);

% import the mat file with all the subject heights (gabe)
heights = load('subject_heights.mat');

%%%% This part is only needed if including segmentation %%%%%
% segmentDir = '/Users/adam2392/Desktop';
% segmentFile = fullfile(segmentDir, 'Camera1_Walk_Segmented.csv');
% csvDir = '/04_Skeleton_Coords/Camera1_Walk'; 
% csv_files = fullfile(mainDir, csvDir); 

%% 02: Generate MAT files for steps
for iii = 1:length(subj_string)
    
    disp(subj_string{iii})  % displays current subject we are on...
    % get the height for current subject if available (gabe)
    try
        hasHeight = true;
        height = heights.heights.(cat(2,'s',subj_string{iii}(1:3)));
    catch
        disp(cat(2,'No height information for subject: ',subj_string{iii}));
        hasHeight = false;
        height = 1; % doesn't matter, if has_height false this will be ignored
    end
    % 9 Tests per .mat file
    %%%% This part is only needed if including segmentation %%%%%
%     ranges = markSegments(csv_files, expName, subj_string{iii}, segmentFile); 
%     test_starts = []; % Indices for the start of tests for a sample. 

    sub = {strrep(subj_string{iii},'.','_')};   % replace the '.' w/ '_'
    
    % load up the mat file
    load_string = strcat(mat_files, 'Subj_', sub{1});
    load(load_string)
    
    % create a placeholder var for the mat file
    eval(['placeholder_Name =' 'Subj_' sub{1} ';'])

    % Moving average filter for smoothing
    ankle_diff = placeholder_Name.Walk.ankle_left.x - ...
        placeholder_Name.Walk.ankle_right.x; 
    
    % get the time_stamps
    time_stamps = placeholder_Name.Walk.time_stamp;

    head = placeholder_Name.Walk.head;
    
    %%%% This part is only needed if including segmentation %%%%%
%     timeSplit = regexp(time_stamps{:},'\_','split');
%      minutes = 60000*str2double(timeSplit{1});
%      seconds = 1000*str2double(timeSplit{2});
%      milliseconds = str2double(timeSplit{3});
%      total = minutes+seconds+milliseconds;
%     time = total;
    
%     for jjj = 1:size(ranges, 1)
%         %% Calculate step and store it in variable
%         if(~isnumeric(placeholder_Name.Walk.ankle_left.x(ranges(jjj, 1):ranges(jjj, 2))))
%              ankle_diff = [ankle_diff; ...
%                 str2double(placeholder_Name.Walk.ankle_left.x(ranges(jjj, 1):ranges(jjj, 2))) - ... 
%                 str2double(placeholder_Name.Walk.ankle_right.x(ranges(jjj, 1):ranges(jjj, 2)))];
%             
%             head = [head; str2double(placeholder_Name.Walk.head.x(ranges(jjj, 1):ranges(jjj, 2)))];
%         else   
%             ankle_diff = [ankle_diff; ...
%                 placeholder_Name.Walk.ankle_left.x(ranges(jjj, 1):ranges(jjj, 2)) - ... 
%                 placeholder_Name.Walk.ankle_right.x(ranges(jjj, 1):ranges(jjj, 2))];
%             
%             head = [head; placeholder_Name.Walk.head.x(ranges(jjj, 1):ranges(jjj, 2))];
%         end
%         
%         test_starts = [test_starts, length(ankle_diff)];
%         
%         %% Store the time stamps in variable list also -> plot time vs. step
%         time = placeholder_Name.Walk.time_stamp(ranges(jjj,1):ranges(jjj,2));
%       
%         time = NaN(length(time_stamps),1);
    time = [];
    % loop through each step/time point
    for t=1:length(time_stamps)
        %split up the timestamp into its 3 components and then 
        %correct time stamps, if they dont' have enough integers
        if(strcmp(subj_string{iii},'021.2')==1 && t == 6599)
            %Do Nothing. Very strange problem on this index.
            time_stamps{t} = time_stamps{t-1};
        end
        if(strcmp(subj_string{iii},'115')==1 && t == 5155)
            %Do Nothing. Very strange problem on this index.
            time_stamps{t} = time_stamps{t-1};
        end
        
        % splitting up time stamps by ':' or '_'
        if (isempty(strfind(time_stamps{1},':')) == 0)
            csvtimeSplit = regexp(time_stamps{t}, '\:', 'split');
        elseif (isempty(strfind(time_stamps{1},'_')) == 0)
            csvtimeSplit = regexp(time_stamps{t}, '\_', 'split');
        end

        %check if we found the time stamp that is close to the first frame
        %convert to milliseconds
        minutes = 60000*str2double(csvtimeSplit{1});
        seconds = 1000*str2double(csvtimeSplit{2});
        milliseconds = str2double(csvtimeSplit{3});
        total = minutes+seconds+milliseconds;
    
        % create the time vector in milliseconds
        time = [time, total];
    end

    % Run a moving average filter 
    filter_window = 10; 
    step = filter(1/filter_window.*ones(1,filter_window), 1, ankle_diff); 
    
    % store the step length and the highest step
    stepLength = abs(step);
    highestPeak = max(stepLength);

    % Find prominent peaks (see findpeakProminent
    thres = 0.01;
    min_prominence = thres.*(prctile(stepLength, 91) - prctile(stepLength, 9)); 
    [pks, loc, prom] = findpeaksProminent(stepLength, min_prominence);

    % Remove non-oscillating peaks (this removes some potentially useful data
    % right now (but only at the endpoints). 
    peak_signs = diff(sign(step(loc))); 
    ind_remove = [-1*peak_signs(1); peak_signs] == 0; 
    pks(ind_remove == 1) = []; 
    loc(ind_remove == 1) = []; 
    
    % store the sampling rate, and calculate cadence
    sampling_rate = abs(time(end) - time(1))/length(time); %Assume consistent sampling rate
    cadence = diff(loc).*(1/sampling_rate);

    % Very crude estimates of mean peak amplitude and oscillating frequencies.
    amplitude = mean(pks);  % mean of step peaks
    variance = var(pks);    % variance of peaks
    base_frequency = mean(cadence); stdev = std(cadence); 
    adj_frequency = mean(cadence(abs(cadence - base_frequency) < 2*stdev)); 

    % Calculate velocity by looking at the distance/time traveled per step
    % (gabe)
    velocity = zeros(length(pks)-1,1); %The first and last measurement will be 0.
    for i=2:length(pks)
        velocity(i) = abs(pks(i)/(time(loc(i)) - time(loc(i-1)))) * 1000;
    end
    
    %
    
    Subj_Name.pks = pks;                    % the step peak amplitudes
    Subj_Name.loc = loc;                    % index of the pks
    Subj_Name.step = step;                  % left-right ankle difference
    Subj_Name.stepLength = stepLength;      % abs value of step
    Subj_Name.cadence = cadence;            % cadence
    Subj_Name.amplitude = amplitude;        % mean(pks)
    Subj_Name.variance = variance;          % var(pks)
    Subj_Name.frequency = adj_frequency;    % freq. of walk
    Subj_Name.velocity = velocity;          % velocity of walk
    Subj_Name.timestamps = time_stamps;     % the timestamps in string
    Subj_Name.time = time;                  % the time in milliseconds
    % Additional fields (gabe)
    Subj_Name.avgVelocity = nanmean(velocity);
    Subj_Name.hasHeight = hasHeight; % will need to check if height normalized data available
    Subj_Name.hnPks = pks./height;         % hn = height normalized
    Subj_Name.hnStepLength = stepLength./height;
    Subj_Name.hnAmplitude = mean(Subj_Name.hnPks);
    Subj_Name.hnVariance = var(Subj_Name.hnPks);
    Subj_Name.hnVelocity = velocity./height;
    Subj_Name.hnAvgVelocity = nanmean(Subj_Name.hnVelocity);
    
    
%     Subj_Name.samples = test_starts; 
%     Subj_Name.adjtimestamps = timestamps;
    
    % create a directory and assign subject name
    eval(['Subj_' sub{1} '_Step' '= Subj_Name;'])
    if (exist('Processed_StepLength','dir') ~= 7)
        mkdir('Processed_StepLength')
    end

    % save the mat file into directory
    save(['./Processed_StepLength/Subj_' sub{1} '_Step'],['Subj_' sub{1} '_Step'])
end
clearvars -except Subj_*_Step
