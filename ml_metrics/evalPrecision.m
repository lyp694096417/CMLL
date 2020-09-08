function [pk] = evalPrecision(scoreMat, lblMat, k)
%scoreMat and lblMat are nt x L

p = zeros(k, 1);
prevMatch = 0;
for i = 1:k
[~, Jidx] = max(scoreMat, [], 2);
Iidx = (1:length(Jidx))';
linIdx = sub2ind(size(lblMat), Iidx, Jidx);
lbls = lblMat(linIdx);
prevMatch = sum(lbls) + prevMatch;  % accumulative total
p(i) = prevMatch/(i*length(Jidx));
scoreMat(linIdx) = 0;   % for the next (k+1) iter 
end

pk = p(1:2:k);

end