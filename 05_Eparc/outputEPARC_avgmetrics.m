function [ outputTable ] = outputEPARC_avgmetrics( ~ )
%This function looks at EPARC metrics, step length and velocity
%Written by Neil Gandhi

%All subjects provided by EPARC. There are some subjects missing.
subj_string = {'001','002','003','005','006','007','008','009','010',...
    '012.1','012.2','013.1','013.2','014.1','014.2','015.1','015.2','016.1',...
    '016.2','017.1','017.2','020.1','020.2','021.1','021.2','022.1','022.2',...
    '103','104','105','106','107','108','109','110','112','113','114',...
    '115','117','118','119','120','121'};

%  	1)	Missing 11.1, 11.2; 
% 	2)	Subj. 12 only has 9 points. Should have 18. 
% 	3)	Missing Subject 18. ?> This is okay b/c Subject 18 was disqualified.
% 	4)	Missing Subject 19. ?> Subject only has 9 points. Should have 18.


%% Import EPARC Data

for iii = 1:length(subj_string)
    %disp(subj_string{iii})

    %This depends on where you save your image folders **Subject to Change*
    eparc_Dir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/';
    eparc_file_Dir = '05_Eparc/Processed_Eparc/';
   
    %Preparing search to load .mat file in Processed Data
    sub = {strrep(subj_string{iii},'.','_')};
    eparc_filename = fullfile(eparc_Dir,eparc_file_Dir);
    eparc_load_string = strcat(eparc_filename, 'Subj_', sub{1}(1:3),'_EPARC');
    load(eparc_load_string)
    eval(['placeholder_Name =' 'Subj_' sub{1}(1:3) '_EPARC;'])
    data_length = length(placeholder_Name.StepLength);
    
    
        %Check if the subject was ON/OFF pair or not. ON/OFF pair should
        %have 18 data points. Otherwise just ON or control would have 9.
        if (length(placeholder_Name.StepLength) == 18)
            %disp('ON/OFF Pair')
            if (subj_string{iii}(5) == '1')% OFF = 1 (i.e. 15.1)
                
                %Step Stats. Original data in cm. Convert to m by /100.
                avgStep = nanmean(placeholder_Name.StepLength(1:9))/100;
                stdStep = nanstd(placeholder_Name.StepLength(1:9))/100;
                varStep = nanvar(placeholder_Name.StepLength(1:9))/100;
                
                %Vel Stats. Original data in cm. Convert to m by /100.
                avgVel = nanmean(placeholder_Name.Speed(1:9))/100;
                stdVel = nanstd(placeholder_Name.Speed(1:9))/100;
                varVel = nanvar(placeholder_Name.Speed(1:9))/100;
                
               
            elseif (subj_string{iii}(5) == '2') %ON = 2 (i.e. 15.2)
                %Step Stats. Original data in cm. Convert to m by /100.
                avgStep = nanmean(placeholder_Name.StepLength(10:18))/100;
                stdStep = nanstd(placeholder_Name.StepLength(10:18))/100;
                varStep = nanvar(placeholder_Name.StepLength(10:18))/100;
                
                %Vel Stats. Original data in cm. Convert to m by /100.
                avgVel = nanmean(placeholder_Name.Speed(10:18))/100;
                stdVel = nanstd(placeholder_Name.Speed(10:18))/100;
                varVel = nanvar(placeholder_Name.Speed(10:18))/100;           
            end
        else 
            
            %All other subjects (001-010, 103-121)
            avgStep = nanmean(placeholder_Name.StepLength(:))/100;
            stdStep = nanstd(placeholder_Name.StepLength(:))/100;
            varStep = nanvar(placeholder_Name.StepLength(:))/100;
            avgVel = nanmean(placeholder_Name.Speed(:))/100;
            stdVel = nanstd(placeholder_Name.Speed(:))/100; 
            varVel = nanvar(placeholder_Name.Speed(:))/100; 
            
        end
        
        %Create table of stats per subject
        outputTable{iii,1} = subj_string{iii};
        outputTable{iii,2} = avgStep;
        outputTable{iii,3} = varStep;
        outputTable{iii,4} = stdStep;
        outputTable{iii,5} = avgVel;
        outputTable{iii,6} = varVel;
        outputTable{iii,7} = stdVel;
        outputTable{iii,8} = data_length; %Number of entries (9 or 18)
        

end    

%% Step Length

%Parsing out outputTable into step metrics
pdmed.step = cell2mat(outputTable(13:2:27,2));
pdnomed.step = cell2mat(outputTable(12:2:26,2));
control.step = cell2mat(outputTable(28:end,2));

pdmed.avgstep = nanmean(pdmed.step);
pdmed.stdstep = nanstd(pdmed.step);
%pdmed_varstep = nanvar(pdmed_step);

pdnomed.avgstep = nanmean(pdnomed.step);
pdnomed.stdstep = nanstd(pdnomed.step);
%pdnomed_varstep = nanvar(pdnomed_step);

control.avgstep = nanmean(control.step);
control.stdstep = nanstd(control.step);
%control_varstep = nanvar(control_step);

%% Step Variance

pdmed.stepVar = cell2mat(outputTable(13:2:27,3));
pdnomed.stepVar = cell2mat(outputTable(12:2:26,3));
control.stepVar = cell2mat(outputTable(28:end,3));

pdmed.avgstepVar = nanmean(pdmed.stepVar);
pdmed.stdstepVar = nanstd(pdmed.stepVar);

pdnomed.avgstepVar = nanmean(pdnomed.stepVar);
pdnomed.stdstepVar = nanstd(pdnomed.stepVar);

control.avgstepVar = nanmean(control.stepVar);
control.stdstepVar = nanstd(control.stepVar);

%% Velocity

%Parsing out outputTable into Vel metrics
pdmed.vel = cell2mat(outputTable(13:2:27,5));
pdnomed.vel = cell2mat(outputTable(12:2:26,5));
control.vel = cell2mat(outputTable(28:end,5));

pdmed.avgvel = nanmean(pdmed.vel);
pdmed.stdvel = nanstd(pdmed.vel);
%pdmed_varvel = nanvar(pdmed_vel);

pdnomed.avgvel = nanmean(pdnomed.vel);
pdnomed.stdvel = nanstd(pdnomed.vel);
%pdnomed_varvel = nanvar(pdnomed_vel);

control.avgvel = nanmean(control.vel);
control.stdvel = nanstd(control.vel);
%control_varvel = nanvar(control_vel);

%% Velocity Variance

pdmed.velVar = cell2mat(outputTable(13:2:27,6));
pdnomed.velVar = cell2mat(outputTable(12:2:26,6));
control.velVar = cell2mat(outputTable(28:end,6));

pdmed.avgvelVar = nanmean(pdmed.velVar);
pdmed.stdvelVar = nanstd(pdmed.velVar);

pdnomed.avgvelVar = nanmean(pdnomed.velVar);
pdnomed.stdvelVar = nanstd(pdnomed.velVar);

control.avgvelVar = nanmean(control.velVar);
control.stdvelVar = nanstd(control.velVar);

%% Saving Structures

save('./pdmed_eparc_stats','pdmed')
save('./pdnomed_eparc_stats','pdnomed')
save('./control_eparc_stats','control')




end   