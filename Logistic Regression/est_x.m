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