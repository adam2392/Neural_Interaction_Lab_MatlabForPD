function [pks, loc, prom] = findpeaksProminent(data, min_prominence, varargin)
%PEAK_PROMINENCE Same as findPeaks, but only includes peaks with
%min_prominence. See MATLAB documentation for algorithm. 
%TODO Make more efficient

[pks, loc] = findpeaks(data, varargin{:});
prom = zeros(length(pks)); 
for iii = length(pks):-1:1
    pk_location = loc(iii); 
    
    % Find left and right indices where the function reaches at least the
    % same height as the peak. 
    left_end = find(data(1:pk_location) > pks(iii), 1); 
    if isempty(left_end)
        left_end = 1; 
    end
    right_end = find(data(pk_location:end) > pks(iii), 1) + (pk_location - 1); 
    if isempty(right_end)
        right_end = length(data); 
    end

    % Within the range [left_end, peak] and [right_end, peak] find the
    % maximal height differential. This represents the prominence of the
    % peak. 
    prom(iii) = pks(iii) - max([...
        min(data(left_end:pk_location)), ...
        min(data(pk_location:right_end))]);  
    if prom(iii) < min_prominence
        pks(iii) = []; 
        loc(iii) = []; 
        prom(iii) = []; 
    end
    
end



end

