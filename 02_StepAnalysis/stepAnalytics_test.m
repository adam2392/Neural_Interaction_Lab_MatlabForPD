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
subj_test_off = {}; 
subj_test_on = {'013.2', '014.2', '015.2', '017.2'}; 
subj_string = [subj_test_off, subj_test_on]; 

% Locations of subject .mat files generated via importSkeleton as well as
% the CSV files from video (assumed to be same parent directory)
mainDir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD';
matDir = '/01_Setup/Subj_Preprocessed_Data/'; 
csvDir = '/04_Skeleton_Coords/'; 

mat_files = fullfile(mainDir, matDir);
csv_files = fullfile(mainDir, csvDir); 

sampling_rate = 30;

%% Generate MAT files for steps
for iii = 1:length(subj_string)
    
    disp(subj_string{iii})  % displays current subject we are on...

    % 9 Tests per .mat file
    ranges = markSegments(csv_files, 'Walk', subj_string{iii}); 

    sub = {strrep(subj_string{iii},'.','_')}

    load_string = strcat(mat_files, 'Subj_', sub{1})
    load(load_string)

    eval(['placeholder_Name =' 'Subj_' sub{1} ';'])

    % Moving average filter for smoothing
    ankle_diff = []; % ankle_left_x-ankle_right_x
    test_starts = []; % Indices for the start of tests for a sample. 
    for jjj = 1:size(ranges, 1)
        test_starts = [test_starts, length(ankle_diff)];
       
        if(~isnumeric(placeholder_Name.Walk.ankle_left.x(ranges(jjj, 1):ranges(jjj, 2))))
             ankle_diff = [ankle_diff; ...
                str2double(placeholder_Name.Walk.ankle_left.x(ranges(jjj, 1):ranges(jjj, 2))) - ... 
                str2double(placeholder_Name.Walk.ankle_right.x(ranges(jjj, 1):ranges(jjj, 2)))];
        else   
            ankle_diff = [ankle_diff; ...
                placeholder_Name.Walk.ankle_left.x(ranges(jjj, 1):ranges(jjj, 2)) - ... 
                placeholder_Name.Walk.ankle_right.x(ranges(jjj, 1):ranges(jjj, 2))];
        end
    end

    % Run a moving average filter 
    filter_window = 10; 
    step = filter(1/filter_window.*ones(1,filter_window), 1, ankle_diff); 

    stepLength = abs(step);
    highestPeak = max(stepLength);

    % Find prominent peaks (see findpeakProminent
    thres = 0.05;
    min_prominence = thres.*(prctile(stepLength, 91) - prctile(stepLength, 9)); 
    [pks, loc, prom] = findpeaksProminent(stepLength, min_prominence);

    % Remove non-oscillating peaks (this removes some potentially useful data
    % right now (but only at the endpoints). 
    peak_signs = diff(sign(step(loc))); 
    ind_remove = [-1*peak_signs(1); peak_signs] == 0; 
    pks(ind_remove == 1) = []; 
    loc(ind_remove == 1) = []; 

    cadence = diff(loc).*(1/sampling_rate);

    % Very crude estimates of mean peak amplitude and oscillating frequencies.
    amplitude = mean(pks);  % mean of step peaks
    variance = var(pks);    % variance of peaks
    base_frequency = mean(cadence); stdev = std(cadence); 
    adj_frequency = mean(cadence(abs(cadence - base_frequency) < 2*stdev)); 

    Subj_Name.pks = pks;
    Subj_Name.loc = loc;
    Subj_Name.step = step;
    Subj_Name.stepLength = stepLength;
    Subj_Name.cadence = cadence;
    Subj_Name.amplitude = amplitude; 
    Subj_Name.variance = variance;
    Subj_Name.frequency = adj_frequency; 
    Subj_Name.samples = test_starts; 

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
plot(Subj_021_1_Step.step); 
plot(Subj_021_1_Step.loc, Subj_021_1_Step.step(Subj_021_1_Step.loc), ...
    'd', 'MarkerFaceColor', 'g');
yLims = get(gca, 'YLim');
for iii=1:length(Subj_021_1_Step.samples)
    line(Subj_021_1_Step.samples(iii)*ones(1, 2), yLims, 'Color', 'r'); 
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





