function [meanMat, covMat] = ftse_stocks(first, last, asset1, asset2, asset3)
    asset1_expRe = asset1(last) - asset1(first);
    asset2_expRe = asset2(last) - asset2(first);
    asset3_expRe = asset3(last) - asset3(first);
    
    asset1_vector = [];
    asset2_vector = [];
    asset3_vector = [];
    
    for i = first+1: last
        asset1_daily_return = asset1(i) - asset1(i-1);
        asset2_daily_return = asset2(i) - asset2(i-1);
        asset3_daily_return = asset3(i) - asset3(i-1);
        
        asset1_vector = [asset1_vector; asset1_daily_return];
        asset2_vector = [asset2_vector; asset2_daily_return];
        asset3_vector = [asset3_vector; asset3_daily_return];    
    end
    
    meanMat = [asset1_expRe, asset2_expRe, asset3_expRe];
    covMat = cov([asset1_vector, asset2_vector, asset3_vector]);
     
end

