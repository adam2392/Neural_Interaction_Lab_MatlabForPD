% Loops through each combinations of possible sets of training data
% Theoretically should improve performance as more sets are included for training 

function performance = get_performance(R,y)
    [num_trials,~] = size(R);
    performance = zeros(1,num_trials-1);
    for i = 1:num_trials-1
        x = est_x(R(1:i,:),y(1:i));
        correct = 0;
        total = 0;
        for j = i+1:num_trials
            ll_ = get_ll(R(j,:),x);
            if ll_ > 0
                ll = 1;
            else
                ll = 0;
            end
            if ll == y(j)
                correct = correct + 1;
            end
            total = total + 1;
        end
        performance(i) = correct/total;
    end
end