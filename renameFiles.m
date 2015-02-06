%Function written by Adam Li on 02/05/15
%Contact: adam2392@gmail.com if interested in talking about the code
%
%Input: -mainDir is the directory location
%       -toChange is the phrase to change within the filename (e.g. 'c1'
%       -changeTo is the phrase to change to within filename (e.g. 'c2'
%      
%Output: all files within 'dir' have a changed file name
%Description: Rename all files

function renameFiles(mainDir, toChange, changeTo)

    %get all bmp files in the folder as a list
    files = dir(fullfile(mainDir, '*.bmp'));
    
    files = {files.name};   %get all the file names minus extension
    
    %loop through each file
    for id = 1:length(files)
        %find 'toChange' phrase's position within filename
        position = strfind(files{id}, toChange);
        
        %parse the string till before and after 'toChange'
        oldString = files{id};
        preString = name(1:(position-1));
        postString = name((position+2):end);
        
        %put together the new filename
        newString = strcat(preString, changeTo, postString);
        
        %Create the save locations
        oldLocation = strcat(mainDir, oldString);
        newLocation = strcat(mainDir, newString);
        
        %rename file
        movefile(oldLocation, newLocation);
    end
end