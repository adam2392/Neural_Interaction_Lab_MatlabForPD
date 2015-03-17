%Function written by Adam Li on 02/09/15
%Input: - dirName is the directory name location
%       - expName is the experiment name (e.g. walk, sitstand, turn,etc.)
%       with 001/101 and c1/c2
%       - 
%
%Output: - Modifies skeletal data csv file to add marks based on segmented
%files
%
% To run:
% markSegments('/Volumes/NIL_PASS/Camera1/001_August07/001_Color_Walk',
% 'Walk');
% ***Assumes that all csv files are segmented by subject id...
%
%Description: Takes all the segmented files and inserts marks in skeletal
%data csv file to determine which ranges of time series to analyze.

function markSegments(dirName, expName)
    %% Initialize directory name and get initial files and the range of analysis
    currentDir = cd;    %store the current directory
    
    %get all bmp files in the folder as a list
    files = dir(fullfile(dirName, '*.bmp'));
    files = {files.name};   %get all the file names minus extension

    %sort the image names
    sortedImageNames = sortrows(files);
    
    %%Calculate the time stamps
    %find the timestamps of the saved images ->fps-> save into video with same fps
    timeStamp = strfind(sortedImageNames{1}, 'c1');
    if (isempty(timeStamp))
        timeStamp = strfind(sortedImageNames{1}, 'c2');
    end
    
    %get the time stamp at the beginning and end of segments
    firstFrame = sortedImageNames{1}((timeStamp+3):(timeStamp+11));
    lastFrame = sortedImageNames{end}((timeStamp+3):(timeStamp+11));
    
    %% Get the csv file of interest 
    %change directory to location of images and try to find csv files
    cd(dirName);
    csvDir = cd;
    
    try
        %get all csv files in the folder as a list
        csv = dir(fullfile(csvDir, '*.csv'));
        csvName = {csv.name};
    
        if(isempty(csvName))
            throw error;
        end
    catch error
        cd ..   %move up one file to look for the csv files
        csvDir = cd;
        
        %repeat earlier logic to find csv files in folder as a list
        csv = dir(fullfile(csvDir, '*.csv'));
        csvName = {csv.name};
        
        if(isempty(csvName))
            error('No csv files found!\n');
        end
    end
    
    %loop through the found csv files
    for i=1:length(csvName)
        %see if the csv file is found
        index = strfind(csvName{i}, expName);
        
        if(~isempty(index))
            csvFile = csvName{i};
            break;
        end
    end
    
    %set working directory back to the starting directory
    %cd(currentDir);
    
    %% Mark the csv file for analysis
    
%     [head_x,	 head_y,	 head_z,...
%         shoulder_center_x,	 shoulder_center_y,	 shoulder_center_z,...
%         spine_x,	 spine_y,	 spine_z,...
%         hip_center_x,	 hip_center_y,	 hip_center_z,...
%         shoulder_left_x,	 shoulder_left_y,	 shoulder_left_z,...
%         elbow_left_x,	 elbow_left_y,	 elbow_left_z,...
%         wrist_left_x,	 wrist_left_y,	 wrist_left_z,...
%         hand_left_x,	 hand_left_y, hand_left_z,...
%         shoulder_right_x, shoulder_right_y, shoulder_right_z,...
%         elbow_right_x,	 elbow_right_y,	 elbow_right_z,...
%         wrist_right_x,	 wrist_right_y,	 wrist_right_z,...
%         hand_right_x,	 hand_right_y,	 hand_right_z,...
%         hip_left_x,	 hip_left_y,	 hip_left_z,...
%         knee_left_x,  knee_left_y,	 knee_left_z,...
%         ankle_left_x,	 ankle_left_y,	 ankle_left_z,...
%         foot_left_x,	 foot_left_y,	 foot_left_z,...
%         hip_right_x,	 hip_right_y,	 hip_right_z,...
%         knee_right_x,	 knee_right_y,	 knee_right_z,...
%         ankle_right_x,	 ankle_right_y,   ankle_right_z,...
%         foot_right_x,	 foot_right_y,	 foot_right_z,...
%         time_stamp] = csvimport(fullfile(csvDir), ...
%         'columns', {'head_x',	'head_y',  'head_z',...
%         'shoulder_center_x', 'shoulder_center_y', 'shoulder_center_z',...
%         'spine_x', 'spine_y', 'spine_z',...
%         'hip center_x', 'hip center_y', 'hip center_z',...
%         'shoulder left_x', 'shoulder left_y', 'shoulder left_z',...
%         'elbow left_x',	'elbow left_y',	 'elbow left_z',...
%         'wrist left_x',	 'wrist left_y', 'wrist left_z',...
%         'hand left_x',	 'hand left_y',	 'hand left_z',...
%         'shoulder right_x',	 'shoulder right_y', 'shoulder right_z',...
%         'elbow right_x', 'elbow right_y',	'elbow right_z',...
%         'wrist right_x', 'wrist right_y', 'wrist right_z',...
%         'hand right_x',	 'hand right_y', 'hand right_z',...
%         'hip left_x',	 'hip left_y', 'hip left_z',...
%         'knee left_x',  'knee left_y', 'knee left_z',...
%         'ankle left_x',	 'ankle left_y', 'ankle left_z',...
%         'foot left_x',	 'foot left_y', 'foot left_z',...
%         'hip right_x',	 'hip right_y', 'hip right_z',...
%         'knee right_x',	 'knee right_y', 'knee right_z',...
%         'ankle right_x', 'ankle right_y', 'ankle right_z',...
%         'foot right_x',	 'foot right_y', 'foot right_z', 'time_stamp'});
      
          
    filename = csvFile;
    % - Get structure from first line.
    fid  = fopen( filename, 'r' );
    line = fgetl( fid );    %get first line
    fclose( fid );  %close file
    isStrCol = isnan( str2double( regexp( line, '[^\t]+', 'match' )));
    
    % - Build formatSpec for TEXTSCAN.
    fmt = cell( 1, numel(isStrCol) );
    fmt(isStrCol)  = {'%s'};
    fmt(~isStrCol) = {'%f'};
    fmt = [fmt{:}];
    
    % - Read full file.
    fid  = fopen( filename, 'r' );
    data = textscan( fid, fmt, Inf, 'Delimiter', '\t' );
    fclose( fid );
    
    % - Optional: aggregate columns into large cell array.
    for colId = find( ~isStrCol )
        data{colId} = num2cell( data{colId} );
    end
    data = [data{:}] ;
   
    time = [];
    for i=1:length(data)
        %break up the data segments
        temp = textscan(data{i}, '%s', 'Delimiter', ',');
        time = [time; temp{1}(end)];       
    end
    
    epsilon = 0.01;
    
    %loop through time stamps to find the firstFrame - lastFrame range
    %that is within epsilon of each other
    for i=1:length(time)
        %check if we found the time stamp that is close to the first frame
        if (time{1}(i) - firstFrame < epsilon)
            firstIndex = i;  %store the index for where to first start analyzing
        end
        if (time{1}(i) - lastFrame < epsilon)
            lastIndex = i;
        end
    end
            

    %set working directory back to the starting directory
    cd(currentDir);

end