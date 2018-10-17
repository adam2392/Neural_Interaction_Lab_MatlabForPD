function [ h,p,ci,stats ] = OnOffCompare( subj_string )
%Compare globally Off patients vs. On patients

% subj_string = {'012.1','012.2'};

for iii = 1:length(subj_string)
    
    disp(subj_string{iii})
    
    sub = {strrep(subj_string{iii},'.','_')};
    mainDir = '/Users/Neil/Documents/MATLAB/Parkinsons';
    fileDir = '/Processed_StepLength/';
    filename = fullfile(mainDir,fileDir);
    load_string = strcat(filename, 'Subj_', sub{1},'_Step');
    load(load_string)
    
    eval(['placeholder_Name =' 'Subj_' sub{1} '_Step;'])
    
    if iii == 1 || 2
        if (subj_string{iii}(5) == '1')            
            OFFpeaks = placeholder_Name.pks;
        elseif (subj_string{iii}(5) == '2')
            ONpeaks = placeholder_Name.pks;
        end
          
    else
        
        if (subj_string{iii}(5) == '1')           
            OFFpeaks = cat(1,OFFpeaks,placeholder_Name.pks);            
        elseif (subj_string{iii}(5) == '2') 
            ONpeaks = cat(1,ONpeaks,placeholder_Name.pks);
        end
    end
end

[h, p,ci,stats] = ttest2(OFFpeaks,ONpeaks);

% if (exist('Subj_Stats','dir') ~= 7)
%     mkdir('Subj_Stats')
% end
% 
% if (exist('Subj_Stats/StepLength','dir') ~= 7)
%     mkdir('Subj_Stats/StepLength')
% end
% 
save('./Subj_Stats/StepLength/Global_OnOff','h','p','ci','stats')


end



