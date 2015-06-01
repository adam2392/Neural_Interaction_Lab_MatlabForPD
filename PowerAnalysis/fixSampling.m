%---------------------------------------------------------------------------%
% fixSampling function:
% Will ensure that the loaded mat is sampled uniformly
%
%
%
%---------------------------------------------------------------------------%
function [deltaUniform, fs] = fixSampling(loadString, subjNum)
    %for Adam's code in miliseconds
    load(loadString);
    
    %create a dynamic placeholder for whichever step subject number we are on
    eval(['placeholder_Name =' 'Subj_' subjNum '_Step' ';'])
    
    delta = placeholder_Name.step;      %delta is each person's step data
    time_stamp = placeholder_Name.adjtimestamps;    %adj Time Stamps in ms
    
    % convert time stamps to seconds
    for iii=1:length(time_stamp)
        time(iii)=time_stamp(iii)/1000;
    end

    %create time vector in seconds
    time = time-time(1); %start time at 0 seconds

    fs = 100; %new sampling rate [Hz]
    timeUniform =[ 0:(1/fs):time(end)]; %time vector sampled at fs

    %remove time points that are not strictly monotonic
    delta(diff(time)==0)=[]; 
    time(diff(time)==0)=[];

    %interpolate delta to match new uniform time vector sampled at fs
    deltaUniform = interp1(time, delta, timeUniform); 
    
    if (exist('Processed_Spec','dir') ~= 7)
        mkdir('Processed_Spec')
    end

    %Does this need to be here?
%     save placeholderName deltaUniform timeUniform fs
end