function [out] = regAlg_run(trainX, trainY, testX, algorithm)
%% peform Regression Algorithmn
% X: % Inputs: X: [N*D];  Y:[N*K]

W = [];

if strcmp(algorithm, 'ols')
        %Need project to original Y space
        W = inv(trainX' * trainX) * trainX' *trainY;
        degree = testX * W;
        
elseif strcmp(algorithm, 'cart')
        % Project to new space
        for i =1:size(trainY,2)
            tree  = classregtree(trainX, trainY(:,i), 'method', 'regression');
            degree(:,i) = eval(tree, testX);
        end
        
 elseif strcmp(algorithm(1:5), 'ridge')
        lamda  = str2num(algorithm(6:end));  %default
        N = size(trainX,2);
        W = inv(trainX' * trainX + lamda*eye(N)) * trainX' *trainY;
        degree = testX * W;
        
 elseif strcmp(algorithm(1:6), 'kRidge')
        lamda  = str2num(algorithm(7:end));  %default
        par  = mean(pdist(trainX));
        Ktrain = kernelMatrix(trainX, trainX, 'rbf', par); %[N * N]
        Ktest = kernelMatrix(trainX, testX, 'rbf', par);  %[N * M]
        N = size(trainX,1);
        W = inv( lamda * eye(N) + Ktrain) * trainY; %[N * K]
        degree =  Ktest' * W;  %[M * K]

elseif strcmp(algorithm, 'msvr')
        cd('.\msvr\');
        degree = msvr_run(trainX, trainY, testX);  
        cd('..\');
       
elseif strcmp(algorithm, 'mlssvr')
        cd('.\MLSSVR-master\');
        degree = mlssvr_run(testX, testY, trainX, trainY);
        cd('..\');


else
    fprintf('Algorithm %s is not incloded.', algorithm);
end

out.degree = degree;
out.W=W;

end