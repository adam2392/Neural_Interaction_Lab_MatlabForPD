%Function written by Adam Li on 07/28/14
%Contact: adam2392@gmail.com if interested in talking about the code
%
%Input: -dirName is the directory name location
%       -workName is the temporary working directory as a buffer for image
%       saving
%       -expName is the experiment name (e.g. walk, sitstand, turn,etc.)
%       with 001/101 and c1/c2
%       So it would look like 'SitStand_001_c1'
%
% To run:
% saveVideo(0,'Color', 'Walk');
%
%Output: vidOutput is a video file with all the 
%images inputted into the file one by one
%Description: Saves all the color image data into a stream of 

% Example: saveVideo(0, 'Skeleton', 'Walk');

function saveVideo(mainDir, imageDir, expName)
%% Initialize and find all image file names

    %This depends on where you save your image folders **Subject to Change**
    startDir = fullfile('/Volumes/NIL_PASS/Camera1/021.1_November18/Skeleton/Skeleton_Images/');

    %initializes the directory where images are contained
    fullDir = fullfile(startDir);%, mainDir, imageDir, expName);       
    
    %Find all the BMP file names in the 001_Color, or 101_Color folders
    %convert the set of images names to a cell array
    imageNames = dir(fullfile(fullDir,'*.png'));
    imageNames = {imageNames.name};
    
    if(isempty(imageNames))
        imageNames = dir(fullfile(fullDir,'*.bmp'));
        imageNames = {imageNames.name};
    end
    
    %sort file names by extracting time stamp and use them to sort the array
    fileNames = cell(size(imageNames));                 %pre allocate variable
    
    for i=1:length(imageNames)                          %loop through and obtain names
        fileNames(i) = imageNames(i);
    end
    sortedImageNames = sortrows(fileNames);             %sort the names
 
%% Calculate Frame Rate of the Saved Images

    %find the timestamps of the saved images ->fps-> save into video with same fps
    timeStamp = strfind(sortedImageNames{1}, 'c1');
    if (isempty(timeStamp))
        timeStamp = strfind(sortedImageNames{1}, 'c2');
    end
    
    %time stamp arrays
    firstFrame = zeros(3,1);
    lastFrame = zeros(3,1);
    %counter flag
    j=1;
    k=1;
    
    %get the time stamp
    for i=(timeStamp+3):(timeStamp+11)
        if(k>3)             %error check
            disp('Error! k too great');
        end
        
        if(j==1 || j==4)    % minutes and seconds
            temp01 = sortedImageNames{1}(i);
            temp02 = sortedImageNames{1}(i+1);        
            firstFrame(k) = str2double(strcat(temp01, temp02));
            
            temp03 = sortedImageNames{end}(i);
            temp04 = sortedImageNames{end}(i+1);
            lastFrame(k) = str2double(strcat(temp03, temp04));
            k=k+1;
        elseif(j==7)        % milliseconds
            temp01 = sortedImageNames{1}(i);
            temp02 = sortedImageNames{1}(i+1);
            temp03 = sortedImageNames{1}(i+2);
            firstFrame(k) = str2double(strcat(temp01, temp02, temp03));
            
            temp04 = sortedImageNames{end}(i);
            temp05 = sortedImageNames{end}(i+1);
            temp06 = sortedImageNames{end}(i+2);
            lastFrame(k) = str2double(strcat(temp04, temp05, temp06));   
        end  
        j = j+1;
    end
    
    %calculate the fps
    %calc minutes, sec, and ms and normalize them to seconds
    min = (lastFrame(1)-firstFrame(1))*60;
    sec = lastFrame(2)-firstFrame(2);
    ms = (lastFrame(3)-firstFrame(3))/1000;
    totalTime = min+sec+ms;     %calculates total time of the image capture session
    
    fps = length(sortedImageNames)/totalTime;   %calculates fps
    
%% Save into a Video File Section

    %setup name and location of video file
    outputName = strcat(imageDir,'_',expName, '.avi');
    videoFile = fullfile(fullDir, outputName);
    delete(videoFile); %delete videofile if it already exists
    
    %Construct a VideoWriter object, which creates a motion-jpeg avi file
    outputVideo = VideoWriter(videoFile);
    outputVideo.FrameRate = 23;%fps;        %set fps to calculated fps
    outputVideo.Quality = 100;
    open(outputVideo);
    
    %Loop through image sequence and write it to video
    for ii = 1:length(sortedImageNames)
        try
            img = imread(fullfile(fullDir, sortedImageNames{ii}));
        end
        message = strcat({'Writing image '}, sortedImageNames{ii});
        disp(message);
        
        writeVideo(outputVideo, img);
    end

    close(outputVideo); 
    disp('Video Saving done!');
end