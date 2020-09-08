function ml_save_result2( file, MAE,  type)
    type = strrep(type, '-', 'n');
    type = strrep(type, '.', 'd');
    MAE = permute(MAE,[1,3,2])
    if ~exist(file)
        mkdir(file)
    end
    
    file_hmLoss = [file,'/hmLoss.mat'];
    hmLoss = MAE(:,:,1);
    hmLoss = [hmLoss mean(hmLoss')']
    save(file_hmLoss,'hmLoss')
    
    file_oneErr = [file,'/oneErr.mat'];
    oneErr = MAE(:,:,2);
    oneErr = [oneErr mean(oneErr')']
    save(file_oneErr,'oneErr')
      
    file_cover = [file,'/cover.mat'];
    cover = MAE(:,:,3);
    cover = [cover mean(cover')']
    save(file_cover,'cover')
    
    file_rank = [file,'/rank.mat'];
    rank = MAE(:,:,4);
    rank = [rank mean(rank')']
    save(file_rank,'rank')
    
    file_ap = [file,'/ap.mat'];
    ap = MAE(:,:,5);
    ap = [ap mean(ap')']
    save(file_ap,'ap')
    
    file_maAuc = [file,'/maAuc.mat'];
    maAuc = MAE(:,:,6);
    maAuc = [maAuc mean(maAuc')']
    save(file_maAuc,'maAuc')
    
    file_miF1 = [file,'/miF1.mat'];
    miF1 = MAE(:,:,7);
    miF1 = [miF1 mean(miF1')']
    save(file_miF1,'miF1')
    
    file_maF1 = [file,'/maF1.mat'];
    maF1 = MAE(:,:,8);
    maF1 = [maF1 mean(maF1')']
    save(file_maF1,'maF1')
    
    file_miAcc = [file,'/miAcc.mat'];
    miAcc = MAE(:,:,9);
    miAcc = [miAcc mean(miAcc')']
    save(file_miAcc,'miAcc')
    
    file_maAcc = [file,'/maAcc.mat'];
    maAcc = MAE(:,:,10);
    maAcc = [maAcc mean(maAcc')']
    save(file_maAcc,'maAcc')
    
    file_P1 = [file,'/P1.mat'];
    P1 = MAE(:,:,11);
    P1 = [P1 mean(P1')']
    save(file_P1,'P1')
    
    file_P3 = [file,'/P3.mat'];
    P3 = MAE(:,:,12);
    P3 = [P3 mean(P3')']
    save(file_P3,'P3')
    
    file_P5 = [file,'/P5.mat'];
    P5 = MAE(:,:,13);
    P5 = [P5 mean(P5')']
    save(file_P5,'P5')
    
    file_NDCG1 = [file,'/NDCG1.mat'];
    NDCG1 = MAE(:,:,14);
    NDCG1 = [NDCG1 mean(NDCG1')']
    save(file_NDCG1,'NDCG1')
    
    file_NDCG3 = [file,'/NDCG3.mat'];
    NDCG3 = MAE(:,:,15);
    NDCG3 = [NDCG3 mean(NDCG3')']
    save(file_NDCG3,'NDCG3')
    
    file_NDCG5 = [file,'/NDCG5.mat'];
    NDCG5 = MAE(:,:,16);
    NDCG5 = [NDCG5 mean(NDCG5')']
    save(file_NDCG5,'NDCG5')
    

   
end

