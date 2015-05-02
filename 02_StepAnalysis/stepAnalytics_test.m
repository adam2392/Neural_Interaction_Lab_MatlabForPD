% Script written by Neil Gandhi, modified by Madhu Krishnan

% To run, modify the directories mainDir, matDir and csvDir to their 
% appropriate directories. Right now, it's assumed that matDir and csvDir
% are in the same parent directory. 

% Modify the subject strings you wish to examine. This script will output
% the step .mat files into a folder mainDir called ProcessedStepLength.
% Hence, you only need to run this script once. 

% Dependencies:
%   - findpeaksProminent.m
%   - markSegments.m

% At the bottom of this file is a small plotting cell which can be useful
% if you wish to visualize the data and their peaks. 

%% Loading Subject

% Specify the strings you wish to examine. These are the only strings that
% worked with the markSegments (I had to change the file names to end with
% suffix _c1. 
% '013.1', '014.1', '015.1','016.1', '017.1', '020.1', '021.1', '022.1'
% '013.2', '014.2', '015.2', '016.2', '017.2', '021.2', '022.2'
subj_test_off = {'013.1', '014.1', '015.1','016.1', '017.1', '020.1', '021.1', '022.1', '113', '114', '110', '120', '121'}; 
subj_test_on = {'013.2', '014.2', '015.2', '016.2', '017.2', '021.2', '022.2'}; 
subj_string = [subj_test_off, subj_test_on]; 

% Locations of subject .mat files generated via importSkeleton as well as
% the CSV files from video (assumed to be same parent directory)
mainDir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD';
matDir = '/01_Setup/Subj_Preprocessed_Data/'; 
csvDir = '/04_Skeleton_Coords/Camera1_Walk'; 

expName = 'Walk';
segmentDir = '/Users/adam2392/Desktop';
segmentFile = fullfile(segmentDir, 'Camera1_Walk_Segmented.csv');

mat_files = fullfile(mainDir, matDir);
csv_files = fullfile(mainDir, csvDir); 

%% Generate MAT files for steps
for iii = 1:length(subj_string)
    
    disp(subj_string{iii})  % displays current subject we are on...

    % 9 Tests per .mat file
    ranges = markSegments(csv_files, expName, subj_string{iii}, segmentFile); 
    
    sub = {strrep(subj_string{iii},'.','_')}

    load_string = strcat(mat_files, 'Subj_', sub{1})
    load(load_string)

    eval(['placeholder_Name =' 'Subj_' sub{1} ';'])

    % Moving average filter for smoothing
    ankle_diff = []; % ankle_left_x-ankle_right_x
    test_starts = []; % Indices for the start of tests for a sample. 
    time_stamps = [];
    velocity = [];
    head = [];
    time = {};
    
    for jjj = 1:size(ranges, 1)
        %% Calculate step and store it in variable
        if(~isnumeric(placeholder_Name.Walk.ankle_left.x(ranges(jjj, 1):ranges(jjj, 2))))
             ankle_diff = [ankle_diff; ...
                str2double(placeholder_Name.Walk.ankle_left.x(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                str2double(placeholder_Name.Walk.ankle_right.x(ranges(jjj, 1):ranges(jjj, 2)))];
            
            head = [head; str2double(placeholder_Name.Walk.head.x(ranges(jjj, 1):ranges(jjj, 2)))];
        else   
            ankle_diff = [ankle_diff; ...
                placeholder_Name.Walk.ankle_left.x(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                placeholder_Name.Walk.ankle_right.x(ranges(jjj, 1):ranges(jjj, 2))];
            
            head = [head; placeholder_Name.Walk.head.x(ranges(jjj, 1):ranges(jjj, 2))];
        end
        
        test_starts = [test_starts, length(ankle_diff)];
        
        %% Store the time stamps in variable list also -> plot time vs. step
        time = placeholder_Name.Walk.time_stamp(ranges(jjj,1):ranges(jjj,2));
    
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

    % Run a moving average filter 
    filter_window = 10; 
    step = filter(1/filter_window.*ones(1,filter_window), 1, ankle_diff); 

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
    
    sampling_rate = abs(time_stamps(end) - time_stamps(1))/length(time_stamps);
    cadence = diff(loc).*(1/sampling_rate);

    % Very crude estimates of mean peak amplitude and oscillating frequencies.
    amplitude = mean(pks);  % mean of step peaks
    variance = var(pks);    % variance of peaks
    base_frequency = mean(cadence); stdev = std(cadence); 
    adj_frequency = mean(cadence(abs(cadence - base_frequency) < 2*stdev)); 

    % Calculate velocity from head vector
    for i=1:length(head)-1
        velocity = [velocity; (head(i+1)-head(i))/(time_stamps(i+1) - time_stamps(i))];
    end
    
    Subj_Name.pks = pks;
    Subj_Name.loc = loc;
    Subj_Name.step = step;
    Subj_Name.stepLength = stepLength;
    Subj_Name.cadence = cadence;
    Subj_Name.amplitude = amplitude; 
    Subj_Name.variance = variance;
    Subj_Name.frequency = adj_frequency; 
    Subj_Name.samples = test_starts; 
    Subj_Name.velocity = velocity;
%     Subj_Name.snr = snr;
    Subj_Name.timestamps = time_stamps;

    eval(['Subj_' sub{1} '_Step' '= Subj_Name;'])

    if (exist('Processed_StepLength','dir') ~= 7)
        mkdir('Processed_StepLength')
    end

    save(['./Processed_StepLength/Subj_' sub{1} '_Step'],['Subj_' sub{1} '_Step'])

end
clearvars -except Subj_*_Step

%% Plotting specific samples for examination

figure(1); 
hold on; 
plot(Subj_021_1_Step.timestamps,Subj_021_1_Step.step); %plot time vs. step
% plot(Subj_021_1_Step.loc, Subj_021_1_Step.step(Subj_021_1_Step.loc), ...
%     'd', 'MarkerFaceColor', 'g');
yLims = get(gca, 'YLim');
samples = Subj_021_1_Step.samples;
max = max(Subj_021_1_Step.step);
for iii=1:length(Subj_021_1_Step.samples)
    timemark = Subj_021_1_Step.timestamps(samples(iii));
    line([timemark timemark], [-0.8 0.8], 'Color', 'r')
%     line(Subj_021_1_Step.timestamps(samples(iii))*ones(1, 2), yLims, 'Color', 'r'); 
end
title('Subject 20-ON');


%% 
% %% Converting to Theta,R coordinate system
% %Need to allocate theta based on sampling rate and time. not indices.
% theta = zeros(length(step));
% 
% % Theta is 90 deg. and 270 deg. at maximum and minimuim local step
% for i=1:length(loc)
%     
%     if step(loc(i)) < 0
%         theta(loc(i)) = -3*pi/2;
%     elseif step(loc(i)) > 0
%         theta(loc(i)) = pi/2;
%     elseif step(loc(i)) == 0
%         disp('Error in step??')
%     end
%     
% end
% 
% % Function crossing finds zeros from non-continuous data set
% ind = crossing(step);
% 
% 
% if (step(ind(i)-1) > 0 && step(ind(i)+1) < 0)
%     theta(ind(i)) = pi;
% elseif (step(ind(i)-1) < 0 && step(ind(i)+1) > 0)
%     theta(ind(i)) = 0;
% end
% 
% %HOW TO INTERPOLATE THE DATA?





