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
% 'Walk', '001');
% ***Assumes that all csv files are segmented by subject id...
%
%Description: Takes all the segmented files and inserts marks in skeletal
%data csv file to determine which ranges of time series to analyze.

function rangeMat = markSegments(dirName, expName, subjNumber)    
    %% First Method: Initialize directory name and get initial files and the range of analysis
    % 1. get .bmp images as a list
    % 2. calculate time stamps and get fps
    % 3. get time stamps at beginning and end of the segments
%     
%     currentDir = cd;    %store the current directory
%     
%     %get all bmp files in the folder as a list
%     files = dir(fullfile(dirName, '*.bmp'));
%     files = {files.name};   %get all the file names minus extension
% 
%     %sort the image names
%     sortedImageNames = sortrows(files);
%     
%     %%Calculate the time stamps
%     %find the timestamps of the saved images ->fps-> save into video with same fps
%     timeStamp = strfind(sortedImageNames{1}, 'c1');
%     if (isempty(timeStamp))
%         timeStamp = strfind(sortedImageNames{1}, 'c2');
%     end
%     
%     %get the time stamp at the beginning and end of segments
%     firstFrame = sortedImageNames{1}((timeStamp+3):(timeStamp+11));
%     lastFrame = sortedImageNames{end}((timeStamp+3):(timeStamp+11));
%     
    %% Second Method: Read in Analysis Ranges from CSV File
    currentDir = cd;    %store the current directory
    cd('/Users/adam2392/Desktop');
    inputCsv = 'Camera1_Walk_Segmented.csv';
    
    %%% read in the csv file
    filename = inputCsv;
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
    data = [data{:}];   %end data as a cell array
    
    %initialize variables
    foundRange = 0;
    bf = 0;
    startTime = [];
    endTime = [];
    for i=1:length(data)
        %break up the data segments
        temp = textscan(data{i}, '%s', 'Delimiter', ',');
         
        check = strfind(temp{1}(1), subjNumber);
        
        %check if this is the correct subj number and range
        if(~cellfun(@isempty, check) || foundRange == 1)
            foundRange = 1;
            
            
            %loop until you encounter empty cell
            if(cellfun(@isempty, temp{1}(1)))
                bf = 1;
                break;
            end
            
            %query the 2nd and 3rd columns of the csv file
            startTime = [startTime; temp{1}(2)];
            endTime = [endTime; temp{1}(3)]; 
        end
        
        %once break flag is encountered, exit for loop to save time
        if(bf == 1)
            break;
        end
    end
    
    %get rid of 'start' and 'end' 
    startTime = startTime(2:end);
    endTime = endTime(2:end);
    
    %% Get the csv file of interest 
    % 1. try to get all csv files in folder as a list
    % 2. loop through the list and check if one has the expName in it
    
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
    data = [data{:}];
   
    time = [];
    for i=1:length(data)
        %break up the data segments
        temp = textscan(data{i}, '%s', 'Delimiter', ',');
        
        %time is the timestamp list
        time = [time; temp{1}(end)];    
    end
    
    epsilon = 500;
    
%     %% First Method: Marking
%     firstFrameSplit = regexp(firstFrame, '\_', 'split');
%     lastFrameSplit = regexp(lastFrame, '\_', 'split');
%             
%     firstFrameMin = 60000*str2double(firstFrameSplit{1});
%     firstFrameSec = 1000*str2double(firstFrameSplit{2});
%     firstFrameMs = str2double(firstFrameSplit{3});
%     firstFrameTotal = firstFrameMin + firstFrameSec + firstFrameMs;
% 
%     lastFrameMin = 60000*str2double(lastFrameSplit{1});
%     lastFrameSec = 1000*str2double(lastFrameSplit{2});
%     lastFrameMs = str2double(lastFrameSplit{3});
%     lastFrameTotal = lastFrameMin + lastFrameSec + lastFrameMs;
%     
%         
%     %loop through time stamps to find the firstFrame - lastFrame range
%     %that is within epsilon of each other
%     for i=2:length(time)
%         % 1. check if the time stamps have '2', '2', and '3' characters
%         % first
%         % 2. if not, add '0's in front before comparing
%         %check minutes
%         
%         %split up the timestamp into its 3 components and then 
%         %correct time stamps, if they dont' have enough integers
%         csvtimeSplit = regexp(time{i}, '\:', 'split');
%         
%         if(length(csvtimeSplit{1}) == 1) %check length of minutes
%             csvtimeSplit{1} = strcat('0', csvtimeSplit{1});
%         end
%         
%         if(length(csvtimeSplit{2}) == 1) %check length of seconds
%             csvtimeSplit{2} = strcat('00', csvtimeSplit{2});
%         elseif(length(csvtimeSplit{2}) == 2)
%             csvtimeSplit{2} = strcat('0', csvtimeSplit{2});
%         end
%         
%         if(length(csvtimeSplit{3}) == 1) %check length of milliseconds
%             csvtimeSplit{3} = strcat('00', csvtimeSplit{3});
%         elseif(length(csvtimeSplit(3)) == 2)
%             csvtimeSplit{3} = strcat('0', csvtimeSplit{3});
%         end
%         
%         %check if we found the time stamp that is close to the first frame
%         %convert to milliseconds
%         minutes = 60000*str2double(csvtimeSplit{1});
%         seconds = 1000*str2double(csvtimeSplit{2});
%         milliseconds = str2double(csvtimeSplit{3});
%         total = minutes+seconds+milliseconds;
%                
%         if (abs(total - firstFrameTotal) < epsilon)
%             total
%             firstIndex = i  %store the index for where to first start analyzing
%         end
%         if (abs(total - lastFrameTotal) < epsilon)
%             total
%             lastIndex = i
%         end
%     end
    
    %% Second Method: Marking
    
    %initialize the resulting timestamp arrays
    startTimeTotal = zeros(1, length(startTime));
    endTimeTotal = zeros(1, length(endTime));
    
    %loop through
    for i=1:length(startTime)
        startTimeSplit = regexp(startTime{i}, '\_', 'split');
        endTimeSplit = regexp(endTime{i}, '\_', 'split');

        startTimeMin = 60000*str2double(startTimeSplit{1});
        startTimeSec = 1000*str2double(startTimeSplit{2});
        startTimeMs = str2double(startTimeSplit{3});
        startTimeTotal(i) = startTimeMin + startTimeSec + startTimeMs;

        endTimeMin = 60000*str2double(endTimeSplit{1});
        endTimeSec = 1000*str2double(endTimeSplit{2});
        endTimeMs = str2double(endTimeSplit{3});
        endTimeTotal(i) = endTimeMin + endTimeSec + endTimeMs;
    end

    
    %loop through time stamps to find the startTime/endTime range
    %that is within epsilon of each other
    index = 1;
    endFound = 0;
    startRange = zeros(9, 1);
    startIndex = zeros(9, 1);
    endIndex = zeros(9, 1);
    for i=2:length(time)
        % 1. check if the time stamps have '2', '2', and '3' characters
        % first
        % 2. if not, add '0's in front before comparing
        %check minutes
        
        %split up the timestamp into its 3 components and then 
        %correct time stamps, if they dont' have enough integers
        csvtimeSplit = regexp(time{i}, '\:', 'split');
        
        % if it is a newer file, where timestamps are separated by _
        % instead of :
        if(length(csvtimeSplit) == 1)
            csvtimeSplit = regexp(time{i}, '\_', 'split');
        end

        if(length(csvtimeSplit{1}) == 1) %check length of minutes
            csvtimeSplit{1} = strcat('0', csvtimeSplit{1});
        end
        
        if(length(csvtimeSplit{2}) == 1) %check length of seconds
            csvtimeSplit{2} = strcat('00', csvtimeSplit{2});
        elseif(length(csvtimeSplit{2}) == 2)
            csvtimeSplit{2} = strcat('0', csvtimeSplit{2});
        end
        
        if(length(csvtimeSplit{3}) == 1) %check length of milliseconds
            csvtimeSplit{3} = strcat('00', csvtimeSplit{3});
        elseif(length(csvtimeSplit(3)) == 2)
            csvtimeSplit{3} = strcat('0', csvtimeSplit{3});
        end
        
        %check if we found the time stamp that is close to the first frame
        %convert to milliseconds
        minutes = 60000*str2double(csvtimeSplit{1});
        seconds = 1000*str2double(csvtimeSplit{2});
        milliseconds = str2double(csvtimeSplit{3});
        total = minutes+seconds+milliseconds;
        
        if(index < 10)
            comparisonStart = abs(total - startTimeTotal(index));
            comparisonEnd = abs(total - endTimeTotal(index));
            %now compare total with the startTimeTotal and endTimeTotal
            if (comparisonStart < epsilon && startRange(index) == 0)
                startIndex(index) = i  %store the index for where to first start analyzing
                startRange(index) = 1;
                endFound = 0;
            end
            
            % if we found the end part of that range
            if (comparisonEnd < epsilon && endFound == 0)
                endFound = 1;
                endIndex(index) = i
                index = index + 1;
            end
        else
            break;
        end
    end
    
    %% Write to CSV File the Marked Segments
    % 1. Go from startTimeTotal(i) to endTimeTotal(i) and compare with '
    % 2. loop through the csv file's time stamps to find analysis ranges
    % within epsilon of our startTimeTotal/endTimeTotal
    % 3. mark the column next to those
    rangeMat = [startIndex, endIndex]
    %set working directory back to the starting directory
    cd(currentDir);

end