function [miAcc maAcc] = accuracy(pre_label, test_target)
% pre_label: [N*K] 

[N K]= size(pre_label);

mic_real = find(test_target ==1);
mic_pre = find(pre_label ==1);
mic_same_num = length(intersect(mic_real ,mic_pre));
miAcc = mic_same_num / ( length(mic_real) + length(mic_pre) -  mic_same_num);

maAcc = 0;
for i=1:K
    mac_real = find(test_target(:,i) ==1);
    mac_pre = find(pre_label(:,i) ==1);
    mac_same_num = length(intersect(mac_real ,mac_pre));
    if (length(mac_real) + length(mac_pre)) == 0
        K=K-1;
    else
        maAcc = maAcc + mac_same_num / ( length(mac_real) + length(mac_pre) - mac_same_num );
    end
end
maAcc = maAcc/K;

end