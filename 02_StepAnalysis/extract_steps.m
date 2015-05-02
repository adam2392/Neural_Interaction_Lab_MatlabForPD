% Remove flat space between steps, discard noisy steps, and make all steps have same sign
function steps = extract_steps(data)
    % Step must go above threshold and below - threshold to be considered a step
    threshold = 0.5*max(data);
    steps = [];
    start = 0;
    state = 0;
    stepcount = 0;
    for i = 1:length(data)-1
        % Ignore flat space, wait till step leaves close to zero boundary
        if state == -1
            if abs(data(i)) < 0.05*threshold && abs(data(i+1)) > 0.07*threshold
                start = i;
                if data(i+1) > data(i)
                    state = 0;
                else
                    state = 1;
                end
            end
        end
        % looking for first peak (left foot first)
        if state == 0
            if data(i+1) < data(i)
                if data(i) < threshold
                    state = -1;
                else
                    state = 2;
                end
            end
        end
        % looking for first valley (right foot first)
        if state == 1
            if data(i+1) > data(i)
                if data(i) > - threshold
                    state = -1;
                else
                    state = 3;
                end
            end
        % looking for second valley (right foot second)
        elseif state == 2
            if data(i+1) > data(i)
                if data(i) > -threshold
                    state = 0;
                    start = i;
                else
                    state = 4;
                end
            end
        % looking for second peak (left foot second)
        elseif state == 3
            if data(i+1) < data(i)
                if data(i) < threshold
                    state = 0;
                    start = i;
                else
                    state = 5;
                end
            end
        % looking for end of left right cycle
        elseif state == 4
            if data(i+1) > 0
                steps = horzcat(steps,data(start:i));
                stepcount = stepcount + 1;
                state = -1;
            elseif data(i+1) < data(i)
                if abs(data(i+1)) < 0.1*threshold
                    steps = horzcat(steps,data(start:i));
                    stepcount = stepcount + 1;
                    state = -1;
                else
                    state = -1;
                end
            end
        % looking for end of right left cycle
        elseif state == 5
            if data(i+1) < 0
                % If step found, invert it to match left-right cycle
                steps = horzcat(steps,-(data(start:i)));
                stepcount = stepcount + 1;
                state = -1;
            elseif data(i+1) > data(i)
                if abs(data(i+1)) < 0.1*threshold
                    steps = horzcat(steps,data(start:i));
                    stepcount = stepcount + 1;
                    state = -1;
                else
                    state = -1;
                end
            end
        end
    end