%Function written by Adam Li on 02/09/15
%Input: - dirName is the directory with the csv file or directory below it..
%       - expName is the experiment name
%       - subjNumber is the subject number
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
    
    %%%%%% Change this if needed
    cd('/Users/adam2392/Desktop');
    inputCsv = 'Camera1_Walk_Segmented.csv';
    %%%%%%
    
    
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
        
        subjindex = strfind(csvName{i}, subjNumber);
        
        if(~isempty(index) && ~isempty(subjindex))
            csvFile = csvName{i}
            break;
        end
    end
    
    %set working directory back to the starting directory
    %cd(currentDir);
    
    %% Mark the csv file for analysis
            
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

    %%% First method
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
                startIndex(index) = i;  %store the index for where to first start analyzing
                startRange(index) = 1;
                endFound = 0;
                
            end
            
            % if we found the end part of that range
            if (comparisonEnd < epsilon && endFound == 0)
                endFound = 1;
                endIndex(index) = i;
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