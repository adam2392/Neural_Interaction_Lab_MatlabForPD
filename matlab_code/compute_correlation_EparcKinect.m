kinect_subj_string = {'013_1','013_2','014_1','014_2',...
    '015_1','015_2','016_1','016_2','017_1','017_2','020_1','020_2',...
    '021_1','021_2','022_1','022_2'};
eparc_subj_string = {'013', '014', '015', '016', '017', '020', '021', '022'};


eparc_subj_string = {'103', '104', '105', '106', '107', '108', '109', ...
    '110', '112', '113', '114', '115', '117', '118', '119', '120', '121'};
kinect_subj_string = eparc_subj_string;

% Add paths for EPARC and Kinect Things about Lower Gait
addpath('/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/02_StepAnalysis/Processed_StepLength/')
addpath('/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/05_Eparc/Processed_Eparc')

iESubj = 1
stepLength_corrCoef = [];
velocity_corrCoef = [];
subjects = {};

index = 1;

%%- 01: Loop through each subject
for iSubj=1:length(kinect_subj_string)
    kinect_subj = kinect_subj_string{iSubj}
    kinectfile = strcat('Subj_', kinect_subj, '_Step');
    
    %%- 02: Load in kinect_data
    kinect_data = load(kinectfile);
    fields_kinect = fieldnames(kinect_data);
    kinect_data = kinect_data.(fields_kinect{1});
    
    kinect_velocity = kinect_data.velocity;
    kinect_stepLength = kinect_data.pks;
    
    fprintf('kinect velocity is of length: %f', length(kinect_velocity));
    fprintf('\n')
    fprintf('kinect step length is of length: %f', length(kinect_stepLength));
    
    %%- 02b) Bin velocity and step length into 18 windows
    % and initialize binned vectors
%     numWin = 18;
    numWin = 9;
    kinect_bin_velocity = zeros(numWin,1);
    kinect_bin_stepLength = zeros(numWin,1);
    
    % computer window size for velocity and steplength
    velocityInWin   = floor(length(kinect_velocity)/numWin)
    stepLengthInWin = floor(length(kinect_stepLength)/numWin)
    % go through and bin by windows
    for i=1:numWin
        vel_index_init = (i-1)*velocityInWin+1;
        vel_index_end  = (i)*velocityInWin+1;
        
        step_index_init = (i-1)*stepLengthInWin+1;
        step_index_end = (i)*stepLengthInWin+1;
        
        if i ~= numWin
            try
                vel_avge = mean(kinect_velocity(vel_index_init:vel_index_end));
                stepLength_avge = mean(kinect_stepLength(step_index_init:step_index_end));
            catch e
                i
                throw(e)
            end
        else
            vel_avge = mean(kinect_velocity(vel_index_init:end));
            stepLength_avge = mean(kinect_stepLength(step_index_init:end));
%             length(kinect_velocity(vel_index_init:end))
%             length(kinect_stepLength(step_index_init:end))
        end
        kinect_bin_velocity(i) = vel_avge;
        kinect_bin_stepLength(i) = stepLength_avge;
    end
    
    
    %%- 03: Load in EPARC data: Since it has 18 fields, get the first 9
%     if mod(iSubj,2) == 1 % analyzing part 0.1
    if 1
        eparc_subj = eparc_subj_string{iESubj}
        eparcfile  = strcat('Subj_', eparc_subj, '_EPARC');
        eparc_data = load(eparcfile);
        fields_eparc = fieldnames(eparc_data);
        eparc_data = eparc_data.(fields_eparc{1});
        
        eparc_stepwidth     = eparc_data.StepWidth(1:9);
        eparc_stepLength    = eparc_data.StepLength(1:9);
        eparc_speed         = eparc_data.Speed(1:9);
        
        kinect_steplen = kinect_bin_stepLength(1:9);
        kinect_speed = kinect_bin_velocity(1:9);
        
        % increment index through eparc data
        iESubj = iESubj + 1;
    else                 % analyzing part 0.2
        eparc_stepwidth     = eparc_data.StepWidth(10:end);
        eparc_stepLength    = eparc_data.StepLength(10:end);
        eparc_speed         = eparc_data.Speed(10:end);
        
        kinect_steplen = kinect_bin_stepLength(10:end);
        kinect_speed = kinect_bin_velocity(10:end);
    end
    if sum(isnan(eparc_stepLength)) == 0
        %%- 04: compute correlation between velocity and step length
        stepLength_corr = corrcoef(kinect_steplen, eparc_stepLength)
        speed_corr = corrcoef(kinect_speed, eparc_speed)
        
        stepLength_corr = stepLength_corr(2);
        speed_corr = speed_corr(2);
        
        subjects{index} = kinect_subj_string{iSubj};
        stepLength_corrCoef = [stepLength_corrCoef; stepLength_corr];
        velocity_corrCoef = [velocity_corrCoef; speed_corr];
        
        index = index+1;
        %     stepLength_corr = corr(kinect_bin_stepLength', eparc_stepLength)
    end
end
subjects = subjects';