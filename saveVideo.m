%Function written by Adam Li on 07/28/14
%Input: -dirName is the directory name location
%       -workName is the temporary working directory as a buffer for image
%       saving
%       -expName is the experiment name (e.g. walk, sitstand, turn,etc.)
%       with 001/101 and c1/c2
%       So it would look like 'SitStand_001_c1'
%Output: vidOutput is a video file with all the 
%images inputted into the file one by one
%Description: Saves all the color image data into a stream of 


function saveVideo(mainDir, imageDir, expName)
    
    workingDir = mainDir;              %carries us into Camera_date folder
    
    %Find all the PNG file names in the 001_Color, or 101_Color folders
    %convert the set of images names to a cell array
    imageNames = dir(fullfile(workingDir, imageDir, '*.png'));
    imageNames = {imageNames.name};
    
    %sort file names by extracting time stamp and use them to sort the
    %array
    
    %use sortedImageNames to store final names of all sortd images
    
    
    
    %Construct a VideoWriter object, which creates a motion-jpeg avi file
    %by default
    outputName = strcat('Color_', expName, '.avi');
    outputVideo = VideoWriter(fullfile(workingDir, outputName));
    open(outputVideo);
    
    %Loop through image sequence and write it to video
    for ii = 1:length(sortedImageNames)
        img = imread(fullfile(workingDir, imageDir, sortedImageNames{ii}));
        
        writeVideo(outputVideo, img);
    end
    
    close(outputVideo); 
end