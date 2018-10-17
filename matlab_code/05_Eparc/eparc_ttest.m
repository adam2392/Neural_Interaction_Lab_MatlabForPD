%All subjects provided by EPARC. There are some subjects missing.
% subj_string = {'001','002','003','005','006','007','008','009','010' }%,...
subj_string = {'012.1','012.2','013.1','013.2','014.1','014.2','015.1','015.2','016.1',...
    '016.2','017.1','017.2','020.1','020.2','021.1','021.2','022.1','022.2'};
% subj_string = {'103','104','105','106','107','108','109','110','112','113','114',...
%     '115','117','118','119','120','121'};


% subj_string = {'013.1','013.2'};
% subj_string = {'014.1','014.2'};
% subj_string = {'015.1','015.2'};
% subj_string = {'016.1','016.2'};
% subj_string = {'017.1','017.2'};
% subj_string = {'020.1','020.2'};
% subj_string = {'021.1','021.2'};
subj_string = {'022.1','022.2'};

%  	1)	Missing 11.1, 11.2; 
% 	2)	Subj. 12 only has 9 points. Should have 18. 
% 	3)	Missing Subject 18. ?> This is okay b/c Subject 18 was disqualified.
% 	4)	Missing Subject 19. ?> Subject only has 9 points. Should have 18.


%% Import EPARC Data
avgsteplength = [];
varsteplength = [];
avgspeed = [];
varspeed = [];
% for iii = 1:length(subj_string)
%     %disp(subj_string{iii})
% 
%     %This depends on where you save your image folders **Subject to Change*
%     eparc_Dir = '/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/';
%     eparc_file_Dir = '05_Eparc/Processed_Eparc/';
%    
%     %Preparing search to load .mat file in Processed Data
%     sub = {strrep(subj_string{iii},'.','_')};
%     eparc_filename = fullfile(eparc_Dir,eparc_file_Dir);
%     eparc_load_string = strcat(eparc_filename, 'Subj_', sub{1}(1:3),'_EPARC');
%     load(eparc_load_string);
%     eval(['placeholder_Name =' 'Subj_' sub{1}(1:3) '_EPARC;'])
%     data_length = length(placeholder_Name.StepLength);
%     
%         %Check if the subject was ON/OFF pair or not. ON/OFF pair should
%     %have 18 data points. Otherwise just ON or control would have 9.
%     if (length(placeholder_Name.StepLength) == 18)
%         %disp('ON/OFF Pair')
%         if (subj_string{iii}(5) == '1')% OFF = 1 (i.e. 15.1)
% 
%             %Step Stats. Original data in cm. Convert to m by /100.
%             avgStep = nanmean(placeholder_Name.StepLength(1:9))/100;
%             stdStep = nanstd(placeholder_Name.StepLength(1:9))/100;
%             varStep = nanvar(placeholder_Name.StepLength(1:9))/100;
% 
%             %Vel Stats. Original data in cm. Convert to m by /100.
%             avgVel = nanmean(placeholder_Name.Speed(1:9))/100;
%             stdVel = nanstd(placeholder_Name.Speed(1:9))/100;
%             varVel = nanvar(placeholder_Name.Speed(1:9))/100;
%             
%             avgStep01 = (placeholder_Name.StepLength(1:9))/100;
%             varStep01 = (placeholder_Name.StepLength(1:9))/100;
%             avgVel01 = (placeholder_Name.Speed(1:9))/100;
%             varVel01 = (placeholder_Name.Speed(1:9))/100;
%         elseif (subj_string{iii}(5) == '2') %ON = 2 (i.e. 15.2)
%             %Step Stats. Original data in cm. Convert to m by /100.
%             avgStep = nanmean(placeholder_Name.StepLength(10:18))/100;
%             stdStep = nanstd(placeholder_Name.StepLength(10:18))/100;
%             varStep = nanvar(placeholder_Name.StepLength(10:18))/100;
% 
%             %Vel Stats. Original data in cm. Convert to m by /100.
%             avgVel = nanmean(placeholder_Name.Speed(10:18))/100;
%             stdVel = nanstd(placeholder_Name.Speed(10:18))/100;
%             varVel = nanvar(placeholder_Name.Speed(10:18))/100;
%             
%             avgStep02 = (placeholder_Name.StepLength(10:18))/100;
%             varStep02 = (placeholder_Name.StepLength(10:18))/100;
%             avgVel02 = (placeholder_Name.Speed(10:18))/100;
%             varVel02 = (placeholder_Name.Speed(10:18))/100;
%         end
%     else 
% 
%         %All other subjects (001-010, 103-121)
%         avgStep = nanmean(placeholder_Name.StepLength(:))/100;
%         stdStep = nanstd(placeholder_Name.StepLength(:))/100;
%         varStep = nanvar(placeholder_Name.StepLength(:))/100;
%         avgVel = nanmean(placeholder_Name.Speed(:))/100;
%         stdVel = nanstd(placeholder_Name.Speed(:))/100; 
%         varVel = nanvar(placeholder_Name.Speed(:))/100; 
% 
%     end
%     avgsteplength = [avgsteplength avgStep];
%     varsteplength = [varsteplength varStep];
%     avgspeed = [avgspeed avgVel];
%     varspeed = [varspeed varVel];
% end

%%%%% to test on/off pairs
% [onvsoff.avgstep, onvsoff.avgstep_pvalue] = ttest2(avgStep01, avgStep02);
% [onvsoff.varstep, onvsoff.varstep_pvalue] = vartest2(varStep01, varStep02);
% [onvsoff.avgvel, onvsoff.avgvel_pvalue] = ttest2(avgVel01, avgVel02);
% [onvsoff.varvel, onvsoff.varvel_pvalue] = vartest2(varVel01, varVel02);
% %%%%%
% onvsoff

% avgsteplength'
% varsteplength'
% avgspeed'
% varspeed'

pdnomed_avgstep = [0.4490   0.6592      0.5790	    0.5587	    0.3258	    0.5113	    0.4624	    0.7070	    0.2957];
pdnomed_varstep = [0.0645	    0.0630	    0.6874	    1.5026	    1.9855	    1.4385	    0.6066	   10.2947	    0.4567];
pdnomed_avgvel = [0.5748	    0.8891	    0.7348	    0.7712	    0.4576	    0.5786	    0.7036	    0.6197	    0.4730];
pdnomed_varvel = [0.5985	    1.2747	    0.2882	    0.6798	    2.9747	    1.0709	    0.3022	    1.2359	    0.6067];

pdmed_avgstep = [0.6318	    0.4520	    0.6022	    0.6004	    0.5654	    0.6171	    0.5566	    0.3753	    0.6512	    0.4490	    0.8414	    0.6260	    0.9230	    0.4822	    0.5668	    0.5360	    0.9606	    0.2881];
pdmed_varstep = [0.4903	    0.1718	    0.0667	    0.0877	    1.8387	    0.0677	    0.6274	    0.0478	    0.0980	    0.0645	    1.1343	    0.0445	    8.9217	    1.1074	    0.6681	    0.6473	   16.7960	    0.1731];
pdmed_avgvel = [1.4604	    0.6722	    0.7932	    0.7839	    0.8252	    0.7207	    0.7218	    0.5612	    0.7453	    0.5748	    0.9853	    0.8563	    0.9469	    0.5798	    0.6471	    0.7886	    0.7010	    0.4792];
pdmed_varvel = [364.2316	    0.7095	    0.2370	    1.0099	    1.8036	    0.2085	    0.4838	    0.4988	    0.6499	    0.5985	    0.6646	    1.1876	    1.5876	    2.2206	    1.1823	    0.1981	    0.3784	    0.6984];

control_avgstep = [0.6564	    0.5079	    0.5357	    0.5783	    0.6008	    0.6460	    0.5863	    0.5166	    0.6013	    0.4396	    0.5816	    0.7419	    0.4893	    0.6071	    0.6444	    0.5534	    0.4580];
control_varstep = [0.0314	    0.4875	    0.5111	    0.0560	    0.2995	    0.2933	    0.4089	    0.5390	    0.4285	    0.1089	    7.5006	    1.0503	    5.3926	    0.3260	    2.5898	    0.7057	    0.5834];
control_avgvel = [0.8660	    0.8668	    0.6076	    0.7494	    0.6448	    0.9468	    0.7868	    0.6511	    0.7322	    0.7577	    0.6503	    0.7430	    0.6268	    0.7364	    0.8767	    0.5634	    0.5100];
control_varvel = [2.7455	    0.5463	    2.4493	    0.3488	    2.5102	    0.3175	    2.1298	    0.3731	    0.4080	    0.6619	    0.4263	    0.3130	    1.0374	    1.5181	    1.9549	    0.2448	    1.5070];

% % PDMED vs PDNOMED
[medvsnomed.avgstep, medvsnomed.avgstep_pvalue] = ttest2(pdnomed_avgstep, pdmed_avgstep);
[medvsnomed.varstep, medvsnomed.varstep_pvalue] = ttest2(pdnomed_varstep, pdmed_varstep);
[medvsnomed.avgvel, medvsnomed.avgvel_pvalue] = ttest2(pdnomed_avgvel, pdmed_avgvel);
[medvsnomed.varvel, medvsnomed.varvel_pvalue] = ttest2(pdnomed_varvel, pdmed_varvel);

% % PDMED vs. Control
[medvscontrol.avgstep, medvscontrol.avgstep_pvalue] = ttest2(control_avgstep, pdmed_avgstep);
[medvscontrol.varstep, medvscontrol.varstep_pvalue] = ttest2(control_varstep, pdmed_varstep);
[medvscontrol.avgvel, medvscontrol.avgvel_pvalue] = ttest2(control_avgvel, pdmed_avgvel);
[medvscontrol.varvel, medvscontrol.varvel_pvalue] = ttest2(control_varvel, pdmed_varvel);

% % PDNOMED vs Control
[nomedvscontrol.avgstep, nomedvscontrol.avgstep_pvalue]  = ttest2(control_avgstep, pdnomed_avgstep);
[nomedvscontrol.varstep, nomedvscontrol.varstep_pvalue] = ttest2(control_varstep, pdnomed_varstep);
[nomedvscontrol.avgvel, nomedvscontrol.avgvel_pvalue] = ttest2(control_avgvel, pdnomed_avgvel);
[nomedvscontrol.varvel, nomedvscontrol.varvel_pvalue] = ttest2(control_varvel, pdnomed_varvel);

%% Removing Outliers
% Remove Outliers for Controls
[control_avgstep, control_avgstep_idx, control_avgstep_outliers] = deleteoutliers(control_avgstep, 0.05, 1);
[control_varstep, control_varstep_idx, control_varstep_outliers] = deleteoutliers(control_varstep, 0.05, 1);
[control_avgvel, control_varvel_idx, control_varvel_outliers] = deleteoutliers(control_avgvel, 0.05, 1);
[control_varvel, control_varvel_idx, control_varvel_outliers] = deleteoutliers(control_varvel, 0.05, 1); 

[pdnomed_avgstep, pdnomed_avgstep_idx, pdnomed_avgstep_outliers] = deleteoutliers(pdnomed_avgstep, 0.05, 1);
[pdnomed_varstep, pdnomed_varstep_idx, pdnomed_varstep_outliers] = deleteoutliers(pdnomed_varstep, 0.05, 1);
[pdnomed_avgvel, pdnomed_varvel_idx, pdnomed_varvel_outliers] = deleteoutliers(pdnomed_avgvel, 0.05, 1);
[pdnomed_varvel, pdnomed_varvel_idx, pdnomed_varvel_outliers] = deleteoutliers(pdnomed_varvel, 0.05, 1);  

[pdmed_avgstep, pdmed_avgstep_idx, pdmed_avgstep_outliers] = deleteoutliers(pdmed_avgstep, 0.05, 1);
[pdmed_varstep, pdmed_varstep_idx, pdmed_varstep_outliers] = deleteoutliers(pdmed_varstep, 0.05, 1);
[pdmed_avgvel, pdmed_varvel_idx, pdmed_varvel_outliers] = deleteoutliers(pdmed_avgvel, 0.05, 1);
[pdmed_varvel, pdmed_varvel_idx, pdmed_varvel_outliers] = deleteoutliers(pdmed_varvel, 0.05, 1); 

% % PDMED vs PDNOMED
[medvsnomed.avgstep, medvsnomed.avgstep_pvalue] = ttest2(pdnomed_avgstep, pdmed_avgstep);
[medvsnomed.varstep, medvsnomed.varstep_pvalue] = ttest2(pdnomed_varstep, pdmed_varstep);
[medvsnomed.avgvel, medvsnomed.avgvel_pvalue] = ttest2(pdnomed_avgvel, pdmed_avgvel);
[medvsnomed.varvel, medvsnomed.varvel_pvalue] = ttest2(pdnomed_varvel, pdmed_varvel);

% % PDMED vs. Control
[medvscontrol.avgstep, medvscontrol.avgstep_pvalue] = ttest2(control_avgstep, pdmed_avgstep);
[medvscontrol.varstep, medvscontrol.varstep_pvalue] = ttest2(control_varstep, pdmed_varstep);
[medvscontrol.avgvel, medvscontrol.avgvel_pvalue] = ttest2(control_avgvel, pdmed_avgvel);
[medvscontrol.varvel, medvscontrol.varvel_pvalue] = ttest2(control_varvel, pdmed_varvel);

% % PDNOMED vs Control
[nomedvscontrol.avgstep, nomedvscontrol.avgstep_pvalue]  = ttest2(control_avgstep, pdnomed_avgstep);
[nomedvscontrol.varstep, nomedvscontrol.varstep_pvalue] = ttest2(control_varstep, pdnomed_varstep);
[nomedvscontrol.avgvel, nomedvscontrol.avgvel_pvalue] = ttest2(control_avgvel, pdnomed_avgvel);
[nomedvscontrol.varvel, nomedvscontrol.varvel_pvalue] = ttest2(control_varvel, pdnomed_varvel);


% % Display Mean & SD for Controls
disp('control:');
control_step = [nanmean(control_avgstep),nanstd(control_avgstep)];
disp(control_step);
control_varstep = [nanmean(control_varstep) nanstd(control_varstep)];
disp(control_varstep);
control_vel = [nanmean(control_avgvel) nanstd(control_avgvel)];
disp(control_vel);
control_varvel = [nanmean(control_varvel) nanstd(control_varvel)];
disp(control_varvel);

disp('pdmed')
pdmed_step = [nanmean(pdmed_avgstep),nanstd(pdmed_avgstep)];
disp(pdmed_step);
pdmed_varstep = [nanmean(pdmed_varstep) nanstd(pdmed_varstep)];
disp(pdmed_varstep);
pdmed_vel = [nanmean(pdmed_avgvel) nanstd(pdmed_avgvel)];
disp(pdmed_vel);
pdmed_varvel = [nanmean(pdmed_varvel) nanstd(pdmed_varvel)];
disp(pdmed_varvel);

disp('pdnomed')
pdnomed_step = [nanmean(pdnomed_avgstep),nanstd(pdnomed_avgstep)];
disp(pdnomed_step);
pdnomed_varstep = [nanmean(pdnomed_varstep) nanstd(pdnomed_varstep)];
disp(pdnomed_varstep);
pdnomed_vel = [nanmean(pdnomed_avgvel) nanstd(pdnomed_avgvel)];
disp(pdnomed_vel);
pdnomed_varvel = [nanmean(pdnomed_varvel) nanstd(pdnomed_varvel)];
disp(pdnomed_varvel);
