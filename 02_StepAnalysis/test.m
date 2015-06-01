timestamps = [];
time = Subj_021_1_Step.timestamps(1:segments(1));
timestamps = [timestamps, time];
for i=1:length(segments)
    time = Subj_021_1_Step.timestamps(segments(i)+1:segments(i+1));
    time = time - time(1);
    time = time + timestamps(end);
        
    timestamps = [timestamps, time];    
end