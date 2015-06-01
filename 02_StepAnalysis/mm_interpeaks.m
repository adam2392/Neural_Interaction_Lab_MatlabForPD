%% 
% Test Script to determine if interpeak filtering will lead to better
% analytics. It appears this methodology probably will not be useful. 

%% Setup
load('./Processed_Steps/Subj_015_1_Step')

steps = Subj_015_1_Step.steps{1};
locs = Subj_015_1_Step.loc{1};
pks = Subj_015_1_Step.pks{1};

new_steps = steps; 

%% Filtering
for i=1:length(locs)
    offset = 1;
    win = 15; 
    
    if i == 1
        left_end = 1;
    else
        left_end = locs(i-1) + offset;
    end
    right_end = locs(i) - offset;
    
    win = 15;
    filtered_steps = ...
    filter(1/win.*ones(1, win), 1, steps(left_end:right_end));
    
    % Poor performance below window range.
    new_steps(left_end+win:right_end) = filtered_steps(1+win:end); 
end

%% Plot (original)
figure(1)
hold on
plot(steps)
plot(locs, steps(locs), 'd', 'MarkerFaceColor', 'g')
title('Original')
hold off
saveas(1, 'orig.png')

%% Plot (modified)
figure(2)
hold on
plot(new_steps)
plot(locs, new_steps(locs), 'd', 'MarkerFaceColor', 'g')
t = sprintf('MM Interpeaks: Window %d', win);
title(t)
hold off
saveas(2, 'mod.png')

%% Plot (all filtered)
figure(3)
hold on
filt_steps = filter(1/win.*ones(1, win), 1, steps); 
plot(filt_steps)
% Show that peak locations moved
plot(locs, filt_steps(locs), 'd', 'MarkerFaceColor', 'g') 
sprintf('MM All Points: Window %d', win);
title(t)
hold off
saveas(3, 'all_mod.png')
