% open % Input data from the excel sheet
% run analysis after outlier rejection

% 01:
%% PD No Medication Data

%18 data points
pdnomed_avgstep = [0.084932	0.10909	0.08842	0.10024	0.10604	0.095607	0.14699	0.12472	0.11843	0.10377];
pdnomed_varstep = [0.016863	0.012857	0.0224	0.020575	0.015754	0.0065991	0.019822	0.017655	0.01747	0.0079];
pdnomed_avgvel = [0.59851	0.49214	1.047	0.5791	0.58862	0.28421	0.62388	0.69356	0.98827	0.44177];
pdnomed_varvel = [2.0846	3.238	18.8498	3.9954	4.3037	0.55481	6.85	0.3853	0.50011	0.31501];
pdnomed_totalsteps = [133	77	51	78	94	128	105	98	83	37];
pdnomed_avgcadence = [0.312	0.94461	2.1906	6.3833	1.1575	0.95054	0.70637	1.9725	4.3027	3.1896];
pdnomed_varcadence = [0.52688	1.9134	14.2487	166.1931	6.24	4.3123	0.81994	6.6393	130.1182	24.7313];

%Display Mean and SD Stats for PD No Med
% pdnomed_step = [nanmean(pdnomed_avgstep),nanstd(pdnomed_avgstep)];
% disp(pdnomed_step);
% pdnomed_varstep = [nanmean(pdnomed_varstep) nanstd(pdnomed_varstep)];
% disp(pdnomed_varstep);
% pdnomed_vel = [nanmean(pdnomed_avgvel) nanstd(pdnomed_avgvel)];
% disp(pdnomed_vel);
% pdnomed_varvel = [nanmean(pdnomed_varvel) nanstd(pdnomed_varvel)];
% disp(pdnomed_varvel);
% pdnomed_totalstep = [nanmean(pdnomed_totalsteps) nanstd(pdnomed_totalsteps)];
% disp(pdnomed_totalstep);
% pdnomed_cad = [nanmean(pdnomed_avgcadence) nanstd(pdnomed_avgcadence)];
% disp(pdnomed_cad);
% pdnomed_varcad = [nanmean(pdnomed_varcadence) nanstd(pdnomed_varcadence)];
% disp(pdnomed_varcad);

%% PD Medication Data

%10 data points
pdmed_avgstep = [0.15214	0.11691	0.10845	0.14427	0.079468	0.13491	0.12871	0.10942	0.116	0.10645	0.13498	0.098618	0.12003	0.094489	0.10596	0.10095	0.1101	0.2174	0.10989];
pdmed_varstep = [0.031761	0.020146	0.017638	0.019934	0.01681	0.017644	0.016836	0.013687	0.017552	0.022631	0.014252	0.028109	0.017236 0.01816	0.015984	0.017397 0.019659	0.0219	0.0091764];
pdmed_avgvel = [0.73841	0.33201	0.24885	0.96057	0.63693	0.85831	0.67309	0.64363	0.92673	0.71949	0.59647	0.8638	0.51242	0.66104	0.55109	0.85412	0.87129	1.1261	0.68375];
pdmed_varvel = [2.2834	0.15323	0.078149	24.9951	6.2632	6.5652	5.0103	0.2831	12.9114	2.1688	2.8011	21.1159	6.189	7.8134	3.0613	15.0099	0.62857	0.49908	0.27488];
pdmed_totalsteps = [89	81	12	43	94	56	83	131	48	103	47	80	72	95	105	52	69	105	117];
pdmed_avgcadence = [1.9252	0.65413	2.257	3.0626	8.4375	0.80072	0.70653	0.13375	0.59386	1.1785	0.94032	0.49883	2.4764	0.44577	0.40749	0.80426	2.769	0.61983	2.8673];
pdmed_varcadence = [16.3057	0.92181	5.5084	30.0676	1234.2299	5.0417	1.6674	0.068452	0.85767	5.8598	2.263	0.92737	22.9482	2.2862	0.47862	1.7007	27.7814	4.5071	37.4319];

% Display Mean & SD of PD Med Data
% pdmed_step = [nanmean(pdmed_avgstep),nanstd(pdmed_avgstep)];
% disp(pdmed_step);
% pdmed_varstep = [nanmean(pdmed_varstep) nanstd(pdmed_varstep)];
% disp(pdmed_varstep);
% pdmed_vel = [nanmean(pdmed_avgvel) nanstd(pdmed_avgvel)];
% disp(pdmed_vel);
% pdmed_varvel = [nanmean(pdmed_varvel) nanstd(pdmed_varvel)];
% disp(pdmed_varvel);
% pdmed_totalstep = [nanmean(pdmed_totalsteps) nanstd(pdmed_totalsteps)];
% disp(pdmed_totalstep);
% pdmed_cad = [nanmean(pdmed_avgcadence) nanstd(pdmed_avgcadence)];
% disp(pdmed_cad);
% pdmed_varcad = [nanmean(pdmed_varcadence) nanstd(pdmed_varcadence)];
% disp(pdmed_varcad);

%% Control Data

control_avgstep = [0.15634	0.082634	0.1067	0.12909	0.10552	0.063694	0.06948	0.10245	0.11456	0.11744	0.1714	0.12392	0.11958	0.15175	0.13323	0.12283];
disp(length(control_avgstep))
control_varstep = [0.033764	0.016095	0.012164	0.018885	0.019449	0.011437	0.013538	0.019986	0.016787	0.019089	0.020022	0.013177	0.022243	0.032257	0.022706	0.017431];
control_avgvel = [0.94406	0.66179	0.61029	0.88572	0.74136	0.4185	0.81431	0.6478	0.49994	0.78386	0.85718	0.71684	0.567	0.93457	0.9217	0.77019	0.58393];
control_varvel = [0.65119	5.6288	0.4803	0.45086	0.35124	0.48071	25.911	4.5683	3.0007	7.7011	0.56242	0.52848	0.60056	0.57825	0.67944	0.43294	0.25561];
control_totalsteps = [80	102	73	106	149	44	60	124	107	114	140	130	21	79	106	81	74];
control_avgcadence = [1.0344	0.43907	6.3949	1.7854	2.4077	2.2576	0.85122	0.36297	0.42584	0.26458	0.19974	0.42362	0.50366	3.4569	2.3063	3.3487	2.0218];
control_varcadence = [1.8906	0.46676	209.2986	11.6686	29.2562	28.3223	3.0461	0.42673	0.65562	0.15822	0.22106	0.37227	0.95146	44.0838	13.1134	52.2454	9.745];

% % Display Mean & SD for Controls
% control_step = [nanmean(control_avgstep),nanstd(control_avgstep)];
% disp(control_step);
% control_varstep = [nanmean(control_varstep) nanstd(control_varstep)];
% disp(control_varstep);
% control_vel = [nanmean(control_avgvel) nanstd(control_avgvel)];
% disp(control_vel);
% control_varvel = [nanmean(control_varvel) nanstd(control_varvel)];
% disp(control_varvel);
% control_totalstep = [nanmean(control_totalsteps) nanstd(control_totalsteps)];
% disp(control_totalstep);
% control_cad = [nanmean(control_avgcadence) nanstd(control_avgcadence)];
% disp(control_cad);
% control_varcad = [nanmean(control_varcadence) nanstd(control_varcadence)];
% disp(control_varcad);
% 
% %% t-test w/o removing outliers
% 
% % PDMED vs PDNOMED
% [medvsnomed.avgstep, medvsnomed.avgstep_pvalue] = ttest2(pdnomed_avgstep, pdmed_avgstep);
% [medvsnomed.varstep, medvsnomed.varstep_pvalue] = ttest2(pdnomed_varstep, pdmed_varstep);
% [medvsnomed.avgvel, medvsnomed.avgvel_pvalue] = ttest2(pdnomed_avgvel, pdmed_avgvel);
% [medvsnomed.varvel, medvsnomed.varvel_pvalue] = ttest2(pdnomed_varvel, pdmed_varvel);
% [medvsnomed.totalsteps, medvsnomed.totalsteps_pvalue] = ttest2(pdnomed_totalsteps, pdmed_totalsteps);
% [medvsnomed.avgcadence, medvsnomed.avgcadence_pvalue] = ttest2(pdnomed_avgcadence, pdmed_avgcadence);
% [medvsnomed.varcadence, medvsnomed.varcadence_pvalue] = ttest2(pdnomed_varcadence, pdmed_varcadence)
% 
% % PDMED vs. Control
% [medvscontrol.avgstep, medvscontrol.avgstep_pvalue] = ttest2(control_avgstep, pdmed_avgstep);
% [medvscontrol.varstep, medvscontrol.varstep_pvalue] = ttest2(control_varstep, pdmed_varstep);
% [medvscontrol.avgvel, medvscontrol.avgvel_pvalue] = ttest2(control_avgvel, pdmed_avgvel);
% [medvscontrol.varvel, medvscontrol.varvel_pvalue] = ttest2(control_varvel, pdmed_varvel);
% [medvscontrol.totalsteps, medvscontrol.totalsteps_pvalue]  = ttest2(control_totalsteps, pdmed_totalsteps);
% [medvscontrol.avgcadence, medvscontrol.avgcadence_pvalue] = ttest2(control_avgcadence, pdmed_avgcadence);
% [medvscontrol.varcadence, medvscontrol.varcadence_pvalue] = ttest2(control_varcadence, pdmed_varcadence)
% 
% % PDNOMED vs Control
% [nomedvscontrol.avgstep, nomedvscontrol.avgstep_pvalue]  = ttest2(control_avgstep, pdnomed_avgstep);
% [nomedvscontrol.varstep, nomedvscontrol.varstep_pvalue] = ttest2(control_varstep, pdnomed_varstep);
% [nomedvscontrol.avgvel, nomedvscontrol.avgvel_pvalue] = ttest2(control_avgvel, pdnomed_avgvel);
% [nomedvscontrol.varvel, nomedvscontrol.varvel_pvalue] = ttest2(control_varvel, pdnomed_varvel);
% [nomedvscontrol.totalsteps, nomedvscontrol.totalsteps_pvalue] = ttest2(control_totalsteps, pdnomed_totalsteps);
% [nomedvscontrol.avgcadence, nomedvscontrol.avgcadence_pvalue] = ttest2(control_avgcadence, pdnomed_avgcadence);
% [nomedvscontrol.varcadence, nomedvscontrol.varcadence_pvalue] = ttest2(control_varcadence, pdnomed_varcadence)

%% 02: delete outlier

% Remove Outliers for PD No Med
[pdnomed_avgstep, pdnomed_avgstep_idx, pdnomed_avgstep_outliers] = deleteoutliers(pdnomed_avgstep, 0.05, 1);
[pdnomed_varstep, pdnomed_varstep_idx, pdnomed_varstep_outliers] = deleteoutliers(pdnomed_varstep, 0.05, 1);
[pdnomed_avgvel, pdnomed_varvel_idx, pdnomed_varvel_outliers] = deleteoutliers(pdnomed_avgvel, 0.05, 1);
[pdnomed_varvel, pdnomed_varvel_idx, pdnomed_varvel_outliers] = deleteoutliers(pdnomed_varvel, 0.05, 1);   
[pdnomed_totalsteps, pdnomed_totalsteps_idx, pdnomed_varstep_outliers] = deleteoutliers(pdnomed_totalsteps, 0.05, 1);
[pdnomed_avgcadence, pdnomed_varcadence_idx, pdnomed_varcadence_outliers] = deleteoutliers(pdnomed_avgcadence, 0.05, 1);
[pdnomed_varcadence, pdnomed_varcadence_idx, pdnomed_varcadence_outliers] = deleteoutliers(pdnomed_varcadence, 0.05, 1);

% Display Mean & SD for PD No Med w/o Outliers
pdnomed_step = [nanmean(pdnomed_avgstep),nanstd(pdnomed_avgstep)];
disp(pdnomed_step);
pdnomed_varstep = [nanmean(pdnomed_varstep) nanstd(pdnomed_varstep)];
disp(pdnomed_varstep);
pdnomed_vel = [nanmean(pdnomed_avgvel) nanstd(pdnomed_avgvel)];
disp(pdnomed_vel);
pdnomed_varvel = [nanmean(pdnomed_varvel) nanstd(pdnomed_varvel)];
disp(pdnomed_varvel);
pdnomed_totalstep = [nanmean(pdnomed_totalsteps) nanstd(pdnomed_totalsteps)];
disp(pdnomed_totalstep);
pdnomed_cad = [nanmean(pdnomed_avgcadence) nanstd(pdnomed_avgcadence)];
disp(pdnomed_cad);
pdnomed_varcad = [nanmean(pdnomed_varcadence) nanstd(pdnomed_varcadence)];
disp(pdnomed_varcad);

% Remove Outliers for PD Med
[pdmed_avgstep, pdmed_avgstep_idx, pdmed_avgstep_outliers] = deleteoutliers(pdmed_avgstep, 0.05, 1);
[pdmed_varstep, pdmed_varstep_idx, pdmed_varstep_outliers] = deleteoutliers(pdmed_varstep, 0.05, 1);
[pdmed_avgvel, pdmed_varvel_idx, pdmed_varvel_outliers] = deleteoutliers(pdmed_avgvel, 0.05, 1);
[pdmed_varvel, pdmed_varvel_idx, pdmed_varvel_outliers] = deleteoutliers(pdmed_varvel, 0.05, 1);   
[pdmed_totalsteps, pdmed_totalsteps_idx, pdmed_varstep_outliers] = deleteoutliers(pdmed_totalsteps, 0.05, 1);
[pdmed_avgcadence, pdmed_varcadence_idx, pdmed_varcadence_outliers] = deleteoutliers(pdmed_avgcadence, 0.05, 1);
[pdmed_varcadence, pdmed_varcadence_idx, pdmed_varcadence_outliers] = deleteoutliers(pdmed_varcadence, 0.05, 1);

% Display Mean & SD for PD Med w/o Outliers
pdmed_step = [nanmean(pdmed_avgstep),nanstd(pdmed_avgstep)];
disp(pdmed_step);
pdmed_varstep = [nanmean(pdmed_varstep) nanstd(pdmed_varstep)];
disp(pdmed_varstep);
pdmed_vel = [nanmean(pdmed_avgvel) nanstd(pdmed_avgvel)];
disp(pdmed_vel);
pdmed_varvel = [nanmean(pdmed_varvel) nanstd(pdmed_varvel)];
disp(pdmed_varvel);
pdmed_totalstep = [nanmean(pdmed_totalsteps) nanstd(pdmed_totalsteps)];
disp(pdmed_totalstep);
pdmed_cad = [nanmean(pdmed_avgcadence) nanstd(pdmed_avgcadence)];
disp(pdmed_cad);
pdmed_varcad = [nanmean(pdmed_varcadence) nanstd(pdmed_varcadence)];
disp(pdmed_varcad);

% Remove Outliers for Controls
[control_avgstep, control_avgstep_idx, control_avgstep_outliers] = deleteoutliers(control_avgstep, 0.05, 1);
[control_varstep, control_varstep_idx, control_varstep_outliers] = deleteoutliers(control_varstep, 0.05, 1);
[control_avgvel, control_varvel_idx, control_varvel_outliers] = deleteoutliers(control_avgvel, 0.05, 1);
[control_varvel, control_varvel_idx, control_varvel_outliers] = deleteoutliers(control_varvel, 0.05, 1);   
[control_totalsteps, control_totalsteps_idx, control_varstep_outliers] = deleteoutliers(control_totalsteps, 0.05, 1);
[control_avgcadence, control_varcadence_idx, control_varcadence_outliers] = deleteoutliers(control_avgcadence, 0.05, 1);
[control_varcadence, control_varcadence_idx, control_varcadence_outliers] = deleteoutliers(control_varcadence, 0.05, 1);

% Display Mean & SD for Control w/o Outliers
control_step = [nanmean(control_avgstep),nanstd(control_avgstep)];
disp(control_step);
control_varstep = [nanmean(control_varstep) nanstd(control_varstep)];
disp(control_varstep);
control_vel = [nanmean(control_avgvel) nanstd(control_avgvel)];
disp(control_vel);
control_varvel = [nanmean(control_varvel) nanstd(control_varvel)];
disp(control_varvel);
control_totalstep = [nanmean(control_totalsteps) nanstd(control_totalsteps)];
disp(control_totalstep);
control_cad = [nanmean(control_avgcadence) nanstd(control_avgcadence)];
disp(control_cad);
control_varcad = [nanmean(control_varcadence) nanstd(control_varcadence)];
disp(control_varcad);

%% t-test w/removing outliers
% PDMED vs PDNOMED
[medvsnomed.avgstep, medvsnomed.avgstep_pvalue] = ttest2(pdnomed_avgstep, pdmed_avgstep);
[medvsnomed.varstep, medvsnomed.varstep_pvalue] = ttest2(pdnomed_varstep, pdmed_varstep);
[medvsnomed.avgvel, medvsnomed.avgvel_pvalue] = ttest2(pdnomed_avgvel, pdmed_avgvel);
[medvsnomed.varvel, medvsnomed.varvel_pvalue] = ttest2(pdnomed_varvel, pdmed_varvel);
[medvsnomed.totalsteps, medvsnomed.totalsteps_pvalue] = ttest2(pdnomed_totalsteps, pdmed_totalsteps);
[medvsnomed.avgcadence, medvsnomed.avgcadence_pvalue] = ttest2(pdnomed_avgcadence, pdmed_avgcadence);
[medvsnomed.varcadence, medvsnomed.varcadence_pvalue] = ttest2(pdnomed_varcadence, pdmed_varcadence)

% PDMED vs. Control
[medvscontrol.avgstep, medvscontrol.avgstep_pvalue] = ttest2(control_avgstep, pdmed_avgstep);
[medvscontrol.varstep, medvscontrol.varstep_pvalue] = ttest2(control_varstep, pdmed_varstep);
[medvscontrol.avgvel, medvscontrol.avgvel_pvalue] = ttest2(control_avgvel, pdmed_avgvel);
[medvscontrol.varvel, medvscontrol.varvel_pvalue] = ttest2(control_varvel, pdmed_varvel);
[medvscontrol.totalsteps, medvscontrol.totalsteps_pvalue]  = ttest2(control_totalsteps, pdmed_totalsteps);
[medvscontrol.avgcadence, medvscontrol.avgcadence_pvalue] = ttest2(control_avgcadence, pdmed_avgcadence);
[medvscontrol.varcadence, medvscontrol.varcadence_pvalue] = ttest2(control_varcadence, pdmed_varcadence)

% PDNOMED vs Control
[nomedvscontrol.avgstep, nomedvscontrol.avgstep_pvalue]  = ttest2(control_avgstep, pdnomed_avgstep);
[nomedvscontrol.varstep, nomedvscontrol.varstep_pvalue] = ttest2(control_varstep, pdnomed_varstep);
[nomedvscontrol.avgvel, nomedvscontrol.avgvel_pvalue] = ttest2(control_avgvel, pdnomed_avgvel);
[nomedvscontrol.varvel, nomedvscontrol.varvel_pvalue] = ttest2(control_varvel, pdnomed_varvel);
[nomedvscontrol.totalsteps, nomedvscontrol.totalsteps_pvalue] = ttest2(control_totalsteps, pdnomed_totalsteps);
[nomedvscontrol.avgcadence, nomedvscontrol.avgcadence_pvalue] = ttest2(control_avgcadence, pdnomed_avgcadence);
[nomedvscontrol.varcadence, nomedvscontrol.varcadence_pvalue] = ttest2(control_varcadence, pdnomed_varcadence)
