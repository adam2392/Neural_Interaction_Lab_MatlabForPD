function [d] = Peak_Detection(d,type_string,subj_string)
%INPUT STEP LENGTH TO FIND PEAKS


%DEFINE SAMPLING RATE
sampling_rate = 30;


for iii = 1:length(type_string)
    for ii=1:length(subj_string)
        Step_Filter = abs(d.(type_string{iii}).(subj_string{ii}).Step_Filter);
        
        
        
        [pks, loc] = findpeaks(abs(Step_Filter),'SORTSTR','descend');
        loc = sort(loc);
        step_time = diff(loc).*(1/sampling_rate);
        
%         if iii==1
%             pks = pks(1:5);
%         elseif iii==2
%             pks = pks(1:5);
%         end
            
        
        d.(type_string{iii}).(subj_string{ii}).Peaks = pks;
        d.(type_string{iii}).(subj_string{ii}).Peak_Loc = loc;
        d.(type_string{iii}).(subj_string{ii}).Step_Time = step_time;
        
        % figure
        % plot(pks)
        %
        % step_mean = mean(pks);
        % step_SD = std(pks);
        
        
    end
end


end

