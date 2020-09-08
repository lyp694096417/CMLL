function dis = ml_compute_metrics(degree, pre_label, test_target)
%% Coumpute Muilti-Label metrics
% Inputs: 
% degree:  [N*K] , numeric predicted outputs
% pre_label:  [N*K] , logic predicted labels  {0,1}
% test_target: [N*K], true labels {0,1}

% para is [K*N] 
dis(1,1) = Hamming_loss(pre_label', test_target');  % para is [K*N] 
dis(1,2) = One_error(degree', test_target');
dis(1,3)= Coverage(degree', test_target');
dis(1,4) = Ranking_loss(degree', test_target');
dis(1,5) = Average_precision(degree', test_target');
dis(1,6) = macro_auc_0(degree', test_target');

% para is [N*K] 
[dis(1,7) dis(1,8)] = fbeta(pre_label, test_target, 1); % para is [N*K] 
[dis(1,9) dis(1,10)]  = accuracy(pre_label, test_target);  % para is [N*K] 

dis(1,11:13) = evalPrecision(degree, test_target, 5);
dis(1,14:16) = evalnDCG(degree, test_target, 5);
%dis(1,11) = weighted_HammingLoss(pre_label', test_target');
end

