function K = kernelMatrix(X1, X2, kerType, para)
% KERNELMATRIX
%
% K = kernelmatrix(X1,X2, kerType, para);
%
% Inputs: 
%	X1:	[N*D]  samples in rows and features in columns
%	X2:	[M*D]  samples in rows and features in columns
%	kerType: {'lin' 'poly' 'rbf', 'sam'}
%	para: 
%       rbf kernel: sigma
%       linear kernel:  bias
%       poly kernel: degree 
%
% Output:
%	K: kernel matrix  % [N * M]
%

switch kerType
    case 'lin'%%线性核 k(x,y)=x'*y+c
        K = X1 * X2' + para; % [N * M]

    case 'poly'%%多项式核 k(x,y)=(a*x'*y+c)^d
        K = (X1 * X2' + 1).^para; % [N * M]

    case 'rbf'%%径向基函数 k(x,y)=exp((-|x-y|^2)/(2a^2))
        N = size(X1, 1);
        sumX1 = sum(X1.^2, 2);  % [N * 1]
        M = size(X2, 1);
        sumX2 = sum(X2.^2, 2);  % [M * 1]
        D = repmat(sumX1, 1, M) + repmat(sumX2', N, 1) - 2*X1*X2';  % [N * M]
        K = exp( -D / (2*para^2) );

    case 'sam'
        D = X1*X2';  % [N * M]
        K = exp(-acos(D).^2/(2*para^2));
        
    otherwise
        error(['Unsupported kernel ' ker])
        
end


