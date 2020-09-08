%*********A sample file for running the CMLL/kCMLL algorighm***************
%% Compact Learniing: Dual Space Dimension Reduction 
clc
clear 
%% Paramater
% type = 'cmll';          % method type：{cmll,kcmll}
% dataset = 'msra';       % dataset
% algorithm = 'ridge1e-1';% regression algorithm with parameter: {ridge, kRidge}
% para = 1e-1;            % algorithm 
% times = 5;              % number of chunk
% thr = 40;               % compression ratios for X
% thq = 30;               % compression ratios for Y
type = 'kcmll';          % method type：{cmll,kcmll}
dataset = 'msra';        % dataset
algorithm = 'kRidge1e-4';% regression algorithm with parameter: {ridge, kRidge}
para = 1e1;              % algorithm 
times = 5;               % number of chunk
thr = 90;                % compression ratios for X
thq = 30;                % compression ratios for Y

%% Load dataset 
load([dataset,'.mat']);
n = size(features,1) / times; % number of each chunk 
DimX = size(features,2);
DimY = size(labels,2);
%% Shuffle data
features = features(rand_index, :);
labels = labels(rand_index, :);
%% Cross-validation Process 
filefolder = ['./result_dsdr/',type,'/',dataset];
if ~exist(filefolder)
    mkdir(filefolder)
end
MAE = zeros(1,16,times); % variable to store the results
for i = 1:times
    file = [filefolder, '/',dataset,'_',num2str(i),'.mat'];
    fprintf('%s %s: %ith cross validation\n', type, dataset, i);
    % split dataset 
    trainX = [features(1:round(n*(i-1)),:); features(round(n*i+1):end,:)];
    trainY = [labels(1:round(n*(i-1)),:); labels(round(n*i+1):end,:)];
    testX = features(round(n*(i-1)+1):round(n*i),:);
    testY = labels(round(n*(i-1)+1):round(n*i),:);
    
    dimr = round((thr/100)*DimX);
    if dimr > size(trainX,1)
        dimr = size(trainX,1);
    end
    dimq = round((thq/100)*DimY);
    % perform DR 
    if strcmp(type(1:4),'cmll') 
        [R alphas C betas ]  = dsdr_cmll_iter( trainX, trainY, dimr, dimq, para);
        % Map trainX, testX, trainY 
        newTrainX = trainX * R;
        newTestX = testX * R;
    else
        sigma = 1*mean(pdist(trainX));
        KerX1 = kernelMatrix(trainX, trainX, 'rbf', sigma);
        KerX2 = kernelMatrix(trainX, testX, 'rbf', sigma);
        [R alphas C betas ]  = dsdr_cmll_iter_kerX( trainX, trainY, dimr, dimq, para,KerX1);
        newTrainX = KerX1' * R;
        newTestX = KerX2' * R;
    end
    newTrainY = C;
    oriTrainY = trainY;
    % run regression method
    [out] = regAlg_run(newTrainX, newTrainY, newTestX, algorithm);
    D = newTrainY' * oriTrainY;
    degree = out.degree*D;
    % compute measurement
    pre_label = get_logic_label(degree);
    distance = ml_compute_metrics(degree, pre_label, testY);
    MAE(:,:,i) = distance;
end
%% Save Results
ml_save_result(filefolder, MAE, type);