%% Loading Subject

% subj_string = {'011.1','011.2','012.1','012.2','013.1','013.2','014.1','014.2'};
% subj_string = {'015.1','015.2','016.1','016.2','017.1','017.2','018','019'};
% subj_string = {'020.1','020.2','021.1','022.1,'022.2'};
% PROBLEM WITH 021.2, its in a cell array?

% subj_string = {'002','003','005','006','007','008','009','010'};
%PROBLEM with 001: Does not exist
% subj_string = {'103','104','105','106','107','108','109','110','111','112'...
%     ,'113','114'}; 
subj_string = {'117','118','119','120','121'};
%PROBLEM with 115; it is in cell array
%PROBLEM with 101: Does not exist

for iii = 1:length(subj_string)
disp(subj_string{iii})

sub = {strrep(subj_string{iii},'.','_')};
mainDir = '/Users/Neil/Documents/MATLAB/Parkinsons';
fileDir = '/Subj_Preprocessed_Data/';
filename = fullfile(mainDir,fileDir);
load_string = strcat(filename, 'Subj_', sub{1});
load(load_string)

%% Defining Step
sampling_rate = 30;
eval(['placeholder_Name =' 'Subj_' sub{1} ';'])
step = placeholder_Name.Walk.ankle_left.x - placeholder_Name.Walk.ankle_right.x;

% step = ankle_left_x-ankle_right_x;
stepLength = abs(step);
highestPeak = max(stepLength);
thres = 0.3;

[pks, loc] = findpeaks(stepLength,'MinPeakHeight',thres);

cadence = diff(loc).*(1/sampling_rate);

Subj_Name.pks = pks;
Subj_Name.loc = loc;
Subj_Name.step = step;
Subj_Name.stepLength = stepLength;
Subj_Name.cadence = cadence;

eval(['Subj_' sub{1} '_Step' '= Subj_Name;'])

if (exist('Processed_StepLength','dir') ~= 7)
    mkdir('Processed_StepLength')
end

save(['./Processed_StepLength/Subj_' sub{1} '_Step'],['Subj_' sub{1} '_Step'])
% save(['./Processed_StepLength/Subj_' sub{iii} '_Step'],'step','stepLength','pks','loc')


end

% %% Converting to Theta,R coordinate system
% %Need to allocate theta based on sampling rate and time. not indices.
% theta = zeros(length(step));
% 
% % Theta is 90 deg. and 270 deg. at maximum and minimuim local step
% for i=1:length(loc)
%     
%     if step(loc(i)) < 0
%         theta(loc(i)) = -3*pi/2;
%     elseif step(loc(i)) > 0
%         theta(loc(i)) = pi/2;
%     elseif step(loc(i)) == 0
%         disp('Error in step??')
%     end
%     
% end
% 
% % Function crossing finds zeros from non-continuous data set
% ind = crossing(step);
% 
% 
% if (step(ind(i)-1) > 0 && step(ind(i)+1) < 0)
%     theta(ind(i)) = pi;
% elseif (step(ind(i)-1) < 0 && step(ind(i)+1) > 0)
%     theta(ind(i)) = 0;
% end
% 
% %HOW TO INTERPOLATE THE DATA?





