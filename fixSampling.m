clear all; close all; clc;

load Subj_022_2_theta.mat

%% Import time_stamp from csv
% Initialize variables.
filename = './Skeleton_Walk_022.2_c2_18.csv';
delimiter = ',';
startRow = 2;

% Format string for each line of text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%s%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

% Close the text file.
fclose(fileID);

% Allocate imported array to column variable names
time_stamp = dataArray{:, 1};

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;



%% re-sample data points at uniform sampling rate (fs)

for ii = 1:length(time_stamp)/2 %time_stamp is repeated
    
    temp = char(time_stamp(2*ii)); %convert cell to string
    mins(ii,1) = str2double(temp(1:2)); %minutes
    sec(ii,1) = str2double(temp(4:5)); %seconds
    msec(ii,1) = str2double(temp(7:9)); %milliseconds
    
end

for i=1:length(mins)
    if any(mins(1:i-1)==59) && mins(i)~=59;
        time(i)=((60+mins(i))*60)+sec(i)+(msec(i)/1000);
    else
        time(i)=(mins(i)*60)+sec(i)+(msec(i)/1000);
    end
end
    %create time vector in seconds
time = time-time(1); %start time at 0 seconds

fs = 100; %new sampling rate [Hz]
timeUniform =[ 0:(1/fs):time(end)]; %time vector sampled at fs
%5232

%remove time points that are not strictly monotonic
delta(diff(time)==0)=[]; 
time(diff(time)==0)=[];

%interpolate delta to match new uniform time vector sampled at fs
deltaUniform = interp1(time,delta,timeUniform); 


save Subj_022_2a deltaUniform timeUniform fs