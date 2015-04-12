% Script written by: Adam Li
% Date: April 12, 2015

% Description: 
% Build out an area under the curve model, with inputs from two normal
% distributions. Can be vectors of on, vectors of off and then build out
% log ratio test: log(Pon/Poff) </> tau. Tau can be the constant that is
% looped over.
% 
% Graph power vs. alpha (1-typeII vs. typeI)
% 
% Input: - Non: will be a vector of the form (u, sigma) = (mean, variance)
%        - Noff: will also be a vector of the form (mean, variance)
% 
% Example:
% 
function logRatio(Non, Noff, sample)
    %% Create a normal distribution based off of the input 
    
    % use eqn. for normal distribution to calculate f(x)
    
    
    %% Ratio Test
    tau = 5;    % some constant to compare log ratio test to

end
