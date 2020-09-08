function weighted_HammingLoss=weighted_HammingLoss(Pre_Labels,test_target)
%Computing the hamming loss
%Pre_Labels: the predicted labels of the classifier, if the ith instance belong to the jth class, Pre_Labels(j,i)=1, otherwise Pre_Labels(j,i)=-1
%test_target: the actual labels of the test instances, if the ith instance belong to the jth class, test_target(j,i)=1, otherwise test_target(j,i)=-1

    [num_class,num_instance]=size(Pre_Labels);
    miss_pairs1 = 0
    miss_pairs2 = 0
    for m = 1:num_class
        for n=1:num_instance
            if Pre_Labels(m,n)==1 && test_target(m,n)==0
                miss_pairs1 = miss_pairs1+1
            end
            if Pre_Labels(m,n)==0 && test_target(m,n)==1
                miss_pairs2 = miss_pairs2+1
            end
        end
    end
    weighted_HammingLoss= (miss_pairs1*0.352+miss_pairs2*0.648)/(num_class*num_instance);

