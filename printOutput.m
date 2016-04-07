Pat = '122'

addpath('/Users/adam2392/Documents/MATLAB/Neural_Interaction_Lab_MatlabForPD/02_StepAnalysis/Processed_StepLength')

% load
eval(['load Subj_' Pat '_Step;'])
eval(['data = Subj_' Pat '_Step;'])

meanStepLength = mean(data.stepLength);
varStepLength = var(data.stepLength);
meanVel = mean(data.velocity);
varVel = var(data.velocity);
cadence = data.cadence;



disp(['mean step length is: ' num2str(meanStepLength)])
disp(['variance step length is: ' num2str(varStepLength)])
disp(['mean velocity is: ' num2str(meanVel)])
disp(['variance velocity is: ' num2str(varVel)])
disp(['total steps taken: ' num2str(length(cadence))])
disp(['average cadence: ' num2str(mean(cadence))])
disp(['variance of cadence: ' num2str(var(cadence))])
