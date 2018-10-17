%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/David_Walk_Compiled_016.csv
%


%% Initialize variables.
maindir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/05_Eparc/';
file = 'David_Walk_Compiled_010.csv';

% get the subj_num
underscore = strfind(file, '_');
subjnum = file(underscore(3)+1:underscore(3)+3);

filename = fullfile(maindir, file);
delimiter = ',';
startRow = 2;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: text (%s)
%   column7: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%s%s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
Subject = dataArray{:, 1};
Trial = dataArray{:, 2};
StepWidthcm = dataArray{:, 3};
StepLengthcm = dataArray{:, 4};
Speedcms = dataArray{:, 5};
StepLengthSymmetry = dataArray{:, 6};
Height = dataArray{:, 7};
DateofBirth = dataArray{:, 8};


%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Convert to mat file and saving   
    
% save all eparc data into mat file, 
% Subj_Name.subject = Subject;
% Subj_Name.trial = Trial;
Subj_Name.stepwidth = StepWidthcm;
Subj_Name.steplength = StepLengthcm;
Subj_Name.speed = Speedcms;
Subj_Name.stepsymmetry = StepLengthSymmetry;
% Subj_Name.height = Height;
% Subj_Name.dob = DateofBirth;

sub = subjnum;

% takes subject name and renames it with the subject number
eval(['Subj_' sub '_Eparc' '= Subj_Name;'])

%Creates a folder 
if (exist('Processed_Eparc','dir') ~= 7)
    mkdir('Processed_Eparc')
end

save(['./Processed_Eparc/Subj_' sub '_Eparc'],['Subj_' sub '_Eparc'])