function [R alphas C betas] = dsdr_cmll_iter(X, Y,  d, k, w)
%perform CMLL:  essentially MDDMp + impilcit encoder
% Inputs: X: [N*D];  Y:[N*K]

X=X';  % [D, N]
Y=Y'; % [K, N]
[D, N] = size(X);

% when memory is enough: small datasets, GPU
H=eye(N) - 1/N * ones(N,N);
XH = X*H; % [D * N]
% % when memory is not enough: big datasets run in local
% XH = getAH_Bt(X, eye(N));  % [D * K]

%initialize
%% Step1: Assume any Q,  gtet  R which accords with the st.
KY = Y' * Y;  % [N N]
R = [eye(d); zeros(D-d, d)]; 
B = sqrt(w) * XH' * R;  % [N * d]
V = B*B' + KY; % [N * N]
[tmP1, tmV1] = eig((V+V')/2);  % [N*N]
betas = real(diag(tmV1));
[betas, order] = sort(betas, 'descend');
C = tmP1( : , order); % ith column correspond ith big eigen vector
C = C(:, 1:k); % [N*k]
betas = betas(1:k);

%debug
%fprintf('0th Iter : \n');
%fprintf('    0a: HSIC =  %f \n', w*sum(alphas));
%fprintf('    0b: deError =  %f \n', trace(covY - covY*Q*Q'));
%Target_n = HSIC - deError = w*sum(alphas) -  trace(covY - covY*Q*Q');   is the same as:
Target_n = sum(betas);
%fprintf('    0th: Target =  %f \n', Target_n);


iter = 1;
signal = 1;
while( signal )
    Target_b = Target_n;
    
    fprintf('%ith Iter : \n', iter);
    % fix Q, compute R
    A = sqrt(w) * XH*C;  % [D * k]
    % Note: must use this way to get M, So eig() regard B symmetric 
    % and get "Standardization & Orthogonal " basis
    M = A * A'; % [D*D]
    [tmP2, tmV2] = eig((M+M')/2);  
    alphas = real(diag(tmV2));
    [alphas, order] = sort(alphas, 'descend');
    R = tmP2( : , order); % ith column correspond ith big eigen vector
    R = R(:, 1:d);  % [D*d]
    alphas = alphas(1:d);
    
    % fix R, compute Q 
    B = sqrt(w) * XH' * R;  % [N * d]
    V = B*B' + KY; % [N * N]
    [tmP1, tmV1] = eig((V+V')/2);  % [N*N]
    betas = real(diag(tmV1));
    [betas, order] = sort(betas, 'descend');
    C = tmP1(:, order); % ith column correspond ith big eigen vector
    C = C(:, 1:k); % [N*k]
    betas = betas(1:k);
    
    %Target_n = HSIC -  deError;  is the same as:
    Target_n = sum(betas);
    
    delta = abs(Target_n - Target_b);
    fprintf('    %ith delta = %f \n ', iter, delta);
    if( abs(delta)  / Target_b <= 1e-5 && iter >= 5)
       signal = 0; % stop iteration
    end
   iter = iter+1;
   if( iter > 50)
       fprintf('Alert:   Not converge after 50 iters\n ');
       signal = 0;
   end
end % end while

end