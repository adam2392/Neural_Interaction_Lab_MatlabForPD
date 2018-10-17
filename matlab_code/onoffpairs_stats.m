% get mean +/- std and variance of measures
subjnum = {'011_1', '011_2', '012_1', '012_2', '013_1', '013_2', '014_1', ...
    '014_2', '015_1', '015_2', '016_1', '016_2', '017_1', '017_2', '020_1', ...
    '020_2', '021_1', '021_2', '022_1', '022_2'};

subjnum = {'021_2', '022_1', '022_2'};

addpath('/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/02_StepAnalysis/Processed_StepLength/')

for i=1:length(subjnum)
    disp(sprintf('\n'))
    disp(subjnum{i})
    
    subject = load(['Subj_' subjnum{i} '_Step']);
    
    % step length
    eval(['data = subject.Subj_' subjnum{i} '_Step.stepLength;'])
%     mean(data)
%     sqrt(var(data))
%     var(data)
    

    disp([num2str(mean(data)) ' +/- ' num2str(sqrt(var(data)))]);
    disp(['variance is ' num2str(var(data))]);
    
    % velocity
    eval(['data = subject.Subj_' subjnum{i} '_Step.velocity;'])
%     mean(data)
%     sqrt(var(data))
%     var(data)
    disp([num2str(mean(data)) ' +/- ' num2str(sqrt(var(data)))]);
    disp(['variance is ' num2str(var(data))]);
    
    % total steps
    eval(['data = length(subject.Subj_' subjnum{i} '_Step.pks)'])
    
    % cadence
    eval(['data = subject.Subj_' subjnum{i} '_Step.cadence;'])
%     mean(data)
%     sqrt(var(data))
%     var(data)
    disp([num2str(mean(data)) ' +/- ' num2str(sqrt(var(data)))]);
    disp(['variance is ' num2str(var(data))]);
end