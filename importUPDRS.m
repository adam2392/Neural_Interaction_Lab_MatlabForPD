%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/GaitUPDRSOff_AL.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2015/09/18 22:57:30

%% Initialize variables.
filename = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/GaitUPDRSOn_AL.csv';

delimiter = ',';
startRow = 2;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,3,4,5,7,8,9,10,11,12,13,14,15]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [1,3,4,5,7,8,9,10,11,12,13,14,15]);
rawCellColumns = raw(:, [2,6,16]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
PatientNumber = cell2mat(rawNumericColumns(:, 1));
Date = rawCellColumns(:, 1);
Heightinches = cell2mat(rawNumericColumns(:, 2));
Heightmeters = cell2mat(rawNumericColumns(:, 3));
Age = cell2mat(rawNumericColumns(:, 4));
Gender = rawCellColumns(:, 2);
Weight = cell2mat(rawNumericColumns(:, 5));
Gait = cell2mat(rawNumericColumns(:, 6));
FreezingofGait = cell2mat(rawNumericColumns(:, 7));
LegAgilityRight = cell2mat(rawNumericColumns(:, 8));
LegAgilityLeft = cell2mat(rawNumericColumns(:, 9));
ArisingfromChair = cell2mat(rawNumericColumns(:, 10));
PosturalStability = cell2mat(rawNumericColumns(:, 11));
Posture = cell2mat(rawNumericColumns(:, 12));
GlobalSpontaneityofMovement = cell2mat(rawNumericColumns(:, 13));
VarName16 = rawCellColumns(:, 3);

%% Convert to mat file and saving   
 
updrs.subjnum = PatientNumber;
updrs.age = Age;
updrs.height = Heightmeters;
updrs.gait = Gait;
updrs.freezegait = FreezingofGait;
updrs.agilright = LegAgilityRight;
updrs.agilleft = LegAgilityLeft;
updrs.risechair = ArisingfromChair;
updrs.posturestability = PosturalStability;
updrs.posture = Posture;
updrs.globalspontmove = GlobalSpontaneityofMovement;

% takes subject name and renames it with the subject number
eval(['UPDRS' '= updrs;'])

save('ProcessedUPDRSOn','UPDRS')

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;