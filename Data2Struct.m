function [ d ] = Data2Struct(~)
%Function written by Neil Gandhi, Josh Chu, Adam Li 04/21/14
%Input: .mat files
%Output: data of interest goes into a structure called 'd'
%Description: Extracts data from .mat files and puts it into structure


subj_string = {'CY01','CY02','CY03','CY04','CY05','AL01','AL02','AL03'...
    'AL04','AL05'};
type_string = {'Control','PDSimu'};

files = getAllFiles('/Users/adam2392/Desktop/Senior Design/Acquired Data/Test_Data_392014/');

for iii = 1:length(type_string)
    for ii=1:length(subj_string)
        for i=1:size(files,1)
            curr = files{i};
            
            %Finding the data file per subject
            %checks the size of each string pattern in the file string
            %to see if it is there
            
            %This was meant to search an entire folder 
            if(size(strfind(curr,subj_string{ii}),1)>0 && ...
                    size(strfind(curr,'.mat'),1)>0 && ...
                    size(strfind(curr,type_string{iii}),1)>0)
                
                data_mat = files{i};
                x = struct(load(data_mat));
                x = x.data;
%                 disp('file found')
                
                
            end
            
        end
        
        d.(type_string{iii}).(subj_string{ii}).Raw_Data = x;
        
    end
end
end