function [pre_label] = get_logic_label(degree)
%degree: [N * K]

thr = 0.5; %default
pre_label = degree;
pre_label(find(pre_label<thr)) = 0;
pre_label(find(pre_label>=thr)) = 1;

end