function [r_square] = R_square(params,dm, test_actual, train_actual)
    predict = dm*params;
    predict(predict < 0) = 0;
    sse = sum((test_actual - predict).^2);
    sst = sum((train_actual - mean(train_actual)).^2);
    r_square = 1 - sse/sst;
    

end