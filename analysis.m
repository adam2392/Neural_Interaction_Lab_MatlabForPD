clear all; close all; clc;

load Subj_014_1a.mat

plot(timeUniform,deltaUniform);
xlabel('Time (s)');title('Raw Data');

% Filter data (0.2Hz to 2Hz)
filterObj=fdesign.bandpass('N,Fc1,Fc2',180,0.2,2,fs);
filter = design(filterObj,'window');
deltaFilt = filtfilt(filter.Numerator,1,deltaUniform);

%identify segments with no walking
remove = [0 diff(deltaFilt).^2 < 2e-5];
remove = conv([1,-1],remove); %look for changes from 0-1 and 1-0
remove = [find(remove==1)', find(remove==-1)']; %list locations of changes
remove = remove(diff(remove,1,2)>3*fs,:)-1; %find locations with no activity for 3s
remove = flipud(remove);

%remove data with no walking
deltaWalking = deltaFilt;
for ii = 1:size(remove,1)
    deltaWalking(remove(ii,1):remove(ii,2))=[];
end
timeWalking = (1:length(deltaWalking))/fs; %create new time vector

figure;plot(timeWalking,deltaWalking);
xlabel('Time (s)');title('Walking Only');
save Subj_014_1w timeWalking deltaWalking


% Spectogram
window =  fs*10; %hamming window of length nFFT
overlap = window*.5; %number of samples that each segment overlaps
nFFT = window;
[spec,specFreq,specTime,specPower] = spectrogram(deltaWalking,window,overlap,nFFT,fs,'yaxis');
figure;imagesc(specTime,specFreq,10*log10(specPower));
xlabel('Time (s)');ylabel('Frequency (Hz)'); title('Subject 14 Spectrogram (Pre)')
axis xy;colorbar;colormap jet;ylim([0.2 2]);
caxis([-40 0]); % can change color axis
%you can change this value if you see mostly blue or red
%you can also change it by clicking edit->colormap in the figure menu bar

saveas(gcf,'subj_014_1 spec', 'png')


