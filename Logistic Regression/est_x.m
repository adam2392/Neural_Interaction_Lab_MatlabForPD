% est_x: Written by Gabe
% y is approx = [R]*[x]
% This function takes in:
% - y: patient labels (0,0,...,1,1,0,1,...,1,etc.)
% - R: matrix, where each row is a set of classifiers for patients
% 
% This will use cvx to minimize over x and produce optimal x given y and R
% as training data.

function x_star = est_x(R,y)
    [m1,n] = size(R);
    [m2,~] = size(y);
    if m1 ~= m2
        msg = 'Number of rows in parameters must match';
        error(msg)
    end
    cvx_begin
        variable x(n)
        minimize( sum(log(1+exp(R*x))) - y'*R*x )
    cvx_end
    x_star = x;
end