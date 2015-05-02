% function to produce log liklihood 
% It takes in:
% - R: the set of classifier data for each patient
% - x: the optimal x produced from function 'est_x.m'

function log_likelihood = get_ll(R,x)
    p_on = exp(R*x)/(1+exp(R*x));
    p_off = 1 - p_on;
    log_likelihood = log(p_on/p_off);
end