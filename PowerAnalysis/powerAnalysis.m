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
    
    average50 = [];
    variance50 = [];
    % Analyze each power spectrum and loop through ALPHA=50
    for i=1:length(powerName50)
        % parse out the subject number
        strfind(powerName50{i}, '_fixed');
        subjNum = powerName50{i}(6:strfind(powerName50{i}, '_fixed')-1)

        % load up this specific power mat file
        file = strcat(mainDir, powerDir, powerName50{i});
        subj = load(file);
        
        average50 = [average50, mean(subj.Power)];
        variance50 = [variance50, var(subj.Power)];
        
        temp_avge = mean(mean(subj.Power));
        temp_var = var(var(subj.Power));
        
        Subj_Name.average = mean(subj.Power);
        Subj_Name.variance = var(subj.Power);
        Subj_Name.allAvge = temp_avge;
        Subj_Name.allVar = temp_var;

        eval(['Subj_' subjNum '_PowerAnalysis' '= Subj_Name;'])

        if (exist('Processed_Power','dir') ~= 7)
            mkdir('Processed_Power')
        end

        save(['./Processed_Power/Subj_' subjNum '_PowerAnalysis'],['Subj_' subjNum '_PowerAnalysis'])
    end
    
    average100 = [];
    variance100 = [];
    % Analyze each power spectrum and loop through ALPHA=100
    for i=1:length(powerName100)
        file = strcat(mainDir, powerDir, powerName100{i});
        subj = load(file);
        
        average100 = [average100, mean(subj.Power)];
        variance100 = [variance100, var(subj.Power)];
    end 
        