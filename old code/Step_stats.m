function [s] = Step_stats( d,type_string,subj_string )
%Calculate the statistical difference between Controls & PD

Con_Step = NaN(20,length(subj_string));
Con_Step_Time = NaN(20,length(subj_string));
PD_Step = NaN(20,length(subj_string));
PD_Step_Time = NaN(20,length(subj_string));

for iii = 1:length(type_string)
%     disp(type_string{iii})
    for ii=1:length(subj_string)
%         disp(subj_string{ii})
        Peaks = d.(type_string{iii}).(subj_string{ii}).Peaks;
        Step_Time = d.(type_string{iii}).(subj_string{ii}).Step_Time;
        if iii==1 %if controls
            Con_Step(1:length(Peaks),ii) = Peaks;
            Con_Step_Time(1:length(Step_Time),ii) = Step_Time;
        elseif iii==2 %if simulated
            PD_Step(1:length(Peaks),ii) = Peaks;
            PD_Step_Time(1:length(Step_Time),ii) = Step_Time;
        end
        
    end
end

%save it as a mat file? maybe....
s = struct('Con_Step',Con_Step,'Con_Step_Time',Con_Step_Time,...
     'PD_Step',PD_Step,'PD_Step_Time',PD_Step_Time);

stat_string = {'Con_Step','Con_Step_Time','PD_Step','PD_Step_Time'};

[h p] = ttest2(Con_Step_Time(:),PD_Step_Time(:));
end