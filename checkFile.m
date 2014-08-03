%Function written by Adam Li on 08/02/14
%Copyright: Adam Li
%
%Input: - fileName is the file name to check
%       
%
%Output: - either 1 if the file is not bad, or
%                 0 if the file is bad
%Description: A helper function that gets passed a filename that checks if
%the file is bad or not, by parsing for the string 'bad'
%**Will add some sort of check in main function that calls on this to see if 
%   there is a string of "bad files"

x = function checkFile(fileName)

    if(strfind(fileName, 'Bad'))
        x=0;
    else
        x=1;
    end

end
