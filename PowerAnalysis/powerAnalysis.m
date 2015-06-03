%Function written by Adam Li on 05/21/15
%Input: - subj names
%
%Output: - Analyze the power output of the robust spectrograph
%
% ***Assumes that all csv files are segmented by subject id...
%
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

% function powerAnalysis(subj_string)
    %% Setup is the same for all feature extractions...   
    % Load mat file and set up
    % Locations of subject .mat files generated via importSkeleton as well as 
    % the CSV files from video (assumed to be same parent directory)
    mainDir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD';
    powerDir = '/PowerAnalysis/Processed_Spec/'; 

    power_files = fullfile(mainDir, powerDir);

    %get all the mat files in the folder as a list
    power = dir(fullfile(power_files, '*.mat'));
    powerName = {power.name};
    powerName50 = {};
    powerName100 = {};
    
    %filter out only the a50, or a100 
    for i=1:length(powerName)
        if(~isempty(strfind(powerName{i}, 'a50')))
            powerName50{end+1} = powerName{i};
        elseif(~isempty(strfind(powerName{i}, 'a100')))
            powerName100{end+1} = powerName{i};
        end
    end
    
    subjects = {};
    time_allAvge = [];
    time_allVar = [];
    freq_allAvge = [];
    freq_allVar = [];
    % Analyze each power spectrum and loop through ALPHA=50
    for i=1:length(powerName50)
        % parse out the subject number
        strfind(powerName50{i}, '_fixed');
        subjNum = powerName50{i}(6:strfind(powerName50{i}, '_fixed')-1);

        % load up this specific power mat file
        file = strcat(mainDir, powerDir, powerName50{i});
        subj = load(file);
        
        field = char(fieldnames(subj)); % the field name
        power = subj.(field).Power;     % store the power matrix
        time = [0, subj.(field).time];  % store the time window vector
        freq = subj.(field).freq;       % store the frequency vector (0 - 2 Hz)
        
        %%use the power as weights on the time and freq. scale to find
        %%avge, variance
        % average across all columns
        temp_timeavge = mean(power);
        temp_timevar = var(power);
        
        %average across all rows
        temp_freqavge = mean(power, 2);
        temp_freqvar = var(power, 0, 2);
        
        % weighted average sum of time weights / sum of the power averages
        % along time axis
        
        minimum = min(min(power));  % this is the minimum power from all samples (to be normalized against)
        
        uppersumtime = (temp_timeavge - minimum) .* time;                   % upper sum of weighted avge
        uppersumfreq = (temp_freqavge - minimum) .* transpose(freq);        % upper sum
        
        % carry out weighted avge
        timeavge_weighted = sum(uppersumtime) / sum((temp_timeavge - minimum));       
        freqavge_weighted = sum(uppersumfreq) / sum((temp_freqavge - minimum));
       
        %Plotting to show where the most weighted freq was
%         figure(i);
%         plot(freq, temp_freqavge)               
%         hax = ylim
%         SP=freqavge; %your point goes here 
%         line([SP SP], [hax(1) hax(2)], 'Color', 'r')
  
        % store all the time window average/variances
        Subj_Name.time_average = mean(power);       % time vector averages
        Subj_Name.time_variance = var(power);       % time vector variances
        Subj_Name.time_allAvge = timeavge_weighted; % overall weighted time average
        Subj_Name.time_allVar = var(var(power)); %overall time variance      
        % store all the frequency window average/variances
        Subj_Name.freq_average = mean(power, 2);
        Subj_Name.freq_variance = var(power, 0, 2);
        Subj_Name.freq_allAvge = freqavge_weighted;
        Subj_Name.freq_allVar = var(var(power, 0, 2));
        
        eval(['Subj_' subjNum '_PowerAnalysis' '= Subj_Name;'])

        if (exist('Processed_Power','dir') ~= 7)
            mkdir('Processed_Power')
        end

        save(['./Processed_Power/Subj_' subjNum '_PowerAnalysis'],['Subj_' subjNum '_PowerAnalysis'])
        
        % to create output table
        subjects{i} = char(subjNum);
        time_allAvge = [time_allAvge; Subj_Name.time_allAvge];
        time_allVar = [time_allVar; Subj_Name.time_allVar];
        freq_allAvge = [freq_allAvge; Subj_Name.freq_allAvge];
        freq_allVar = [freq_allVar; Subj_Name.freq_allVar];
    end

    T = table( freq_allAvge, freq_allVar,time_allAvge, time_allVar, 'RowNames', subjects)

    
%     average100 = [];
%     variance100 = [];
%     % Analyze each power spectrum and loop through ALPHA=100
%     for i=1:length(powerName100)
%         file = strcat(mainDir, powerDir, powerName100{i});
%         subj = load(file);
%         
%         average100 = [average100, mean(power)];
%         variance100 = [variance100, var(power)];
%     end 
        