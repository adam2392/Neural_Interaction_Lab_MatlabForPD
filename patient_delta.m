load('Parkinsons_Data/Subj_022_1.mat');
load('Parkinsons_Data/Subj_022_2.mat');
delta_020_1=Subj_022_1.Walk.ankle_left.x - Subj_022_1.Walk.ankle_right.x;
delta_020_2=Subj_022_2.Walk.ankle_left.x - Subj_022_2.Walk.ankle_right.x;

delta=delta_020_1(1:2:end);

save('Parkinsons_Data/Subj_022_1_theta.mat','delta');

delta=delta_020_2(1:2:end);


save('Parkinsons_Data/Subj_022_2_theta.mat', 'delta');
