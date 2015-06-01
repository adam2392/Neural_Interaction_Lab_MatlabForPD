function [xEst,freq,tWin,iter] = specPursuit(data,fs,window,alpha,tol,maxIter)

%-----------------------------------------------------------------------------%
% Written by: Armen Gharibans
% Version: 20150412

% Reference: Ba, D., Babadi, B., Purdon, P. L., & Brown, E. N. (2014). 
% Robust spectrotemporal decomposition by iteratively reweighted least squares. 
% Proceedings of the National Academy of Sciences, 111(50), E5336-E5345.

% Input:
% data: time series (1D vector)
% fs: sampling rate (in Hz)
% window: size of window (equal to number of frequency bands) 
% alpha: model parameter
% tol: tolerance for convergence (default: 0.005)(0 to 0.01)
% maxIter: maximum number of iterations (default: 20)

% Ouput:
% xEst: estimated time-frequency representation of data (complex)
% freq: frequency bands corresponding to xEst
% tWin: time of each window in xEst
% iter: number of iterations until convergence
%-----------------------------------------------------------------------------%

%set default convergence values if not specified
if nargin == 4; tol = 0.005; maxIter = 20; end

%take transpose of data if not set up correctly
[~,ind] = min(size(data));
if ind == 2, data = data'; end;

numSamples = length(data);
W = window;
K = W;
N = floor(numSamples/W);

%define F matrix
F = zeros(W,K);
for l = 1:W
    for k = 1:K/2
        
        F(l,k) = cos(2*pi*l*(k-1)/K);
        F(l,k+K/2) = sin(2*pi*l*(k-1)/K);
        
    end
end

Q = eye(K)*0.001;

%break data up into segments of length W
y = reshape(data(1:W*N),W,N);

iter = 1;
while iter <= maxIter
    %disp(iter)
    
    %Step 1: Filter
    xKalman = zeros(K,N);
    xPredict = zeros(K,N);
    sigKalman = zeros(K,K,N);
    sigPredict = zeros(K,K,N);
    
    xPredict(:,1) = zeros(K,1);
    sigPredict(:,:,1) = eye(K);
    gainK = sigPredict(:,:,1)*F'/(F*sigPredict(:,:,1)*F'+eye(K));
    xKalman(:,1) = xPredict(:,1)+gainK*(y(:,1)-F*xPredict(:,1));
    sigKalman(:,:,1) = sigPredict(:,:,1)-gainK*F*sigPredict(:,:,1);
    
    for n = 2:N
        xPredict(:,n) = xKalman(:,n-1);
        sigPredict(:,:,n) = sigKalman(:,:,n-1)+Q;
        gainK = sigPredict(:,:,n)*F'/(F*sigPredict(:,:,n)*F'+eye(K));
        xKalman(:,n) = xPredict(:,n) + gainK * (y(:,n)-F*xPredict(:,n));
        sigKalman(:,:,n) = sigPredict(:,:,n)-gainK*F*sigPredict(:,:,n);
    end
    
    %Step 2: Smoother
    xSmooth = zeros(K,N);
    sigSmooth = zeros(K,K,N);
    xSmooth(:,N) = xKalman(:,N);
    sigSmooth(:,:,N) = sigKalman(:,:,N);
    
    for n = N-1:-1:1
        B = sigKalman(:,:,n)/(sigPredict(:,:,n+1));
        xSmooth(:,n) = xKalman(:,n) + B*(xSmooth(:,n+1)-xPredict(:,n+1));
        sigSmooth(:,:,n) = sigKalman(:,:,n) + B*(sigSmooth(:,:,n+1)-sigPredict(:,:,n+1))*B';
    end
    
    %Step 4: check for convergence
    if iter>1 && norm(xSmooth-xPrev,'fro')/norm(xPrev,'fro')<tol
        break
    end
    
    %Step 5: Update Q
    Q = zeros(K,K);
    for k = 1:K
        qTemp = 0;
        for n = 2:N
            qTemp = qTemp + (xSmooth(k,n)-xSmooth(k,n-1))^2;
        end
        Q(k,k) = sqrt(qTemp + eps^2)/alpha;
    end
    
    xPrev = xSmooth;
    iter = iter+1;
    
end

xEst = xSmooth(1:K/2,:)-1i*xSmooth(K/2+1:end,:);
freq = (0:K/2-1)*fs/K;
tWin = (1:(N-1))*W/fs;

% figure; imagesc(tWin,freq,20*log10(abs(xEst)));axis xy;colorbar;
% ylabel('Frequency (Hz)');xlabel('Time (s)');
% caxis([-40 10]);colorbar;colormap jet;ylim([0 20]);

end