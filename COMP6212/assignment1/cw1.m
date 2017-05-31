%% load data
load('workbook.mat')

%% 1 (a) portfolio 

m = [0.10, 0.20, 0.15]
init_w = rand(100,3)
modified_w = []
for i = 1:100
    tmp_w = init_w(i,:) / sum(init_w(i,:))
    modified_w = [modified_w;tmp_w]
end

trans_m = modified_w * m'

c = [0.005 -0.010 0.004,
     -0.010 0.040 -0.002,
     0.004 -0.002 0.023]

trans_c = []
for j = 1:100
    tmp_c = modified_w(j,:) * c * modified_w(j,:)'
    trans_c = [trans_c;tmp_c]
end  
trans_cc = power(trans_c, 0.5)
scatter(trans_cc, trans_m, 'filled', 'r')
xlim([0 0.2])
ylim([0.10 0.21])

%% 1(b) efficient frontier

NumPorts = 10;
p = Portfolio;
p = setAssetMoments(p, m, c);
p = setDefaultConstraints(p);

PortWts = estimateFrontier(p, NumPorts);
[PortRisk, PortReturn] = estimatePortMoments(p, PortWts);

%figure();

hold on
plotFrontier(p, NumPorts);

hold off


%% (b) 2 1/2 asset
% function portfolio_comb
% any two asset subset can construct a efficient frontier
port_size = 100;
effic_iter = 10;
m1 = [0.10, 0.20];
c1 = [0.005 -0.010;
      -0.010 0.040];
figure(1);

portfolio_comb(m1, c1, port_size, effic_iter);
text(0.04, 0.12, 'asset1, asset2', 'FontSize', 18);

xlim auto

m2 = [0.20, 0.15];
c2 = [0.040 -0.002;
      -0.002 0.023];
figure(2);
hold on 
portfolio_comb(m2, c2, port_size, effic_iter);
hold off
text(0.14, 0.19, 'asset2, asset3', 'FontSize',18);
xlim auto

m3 = [0.10, 0.15];
c3 = [0.005 0.004;
      0.004 0.023];
figure(3);
hold on 
portfolio_comb(m3, c3, port_size, effic_iter);
hold off
text(0.12, 0.13, 'asset1, asset3', 'FontSize',18);
xlim auto


%% (d)
ExpRet = [0.10, 0.20, 0.15];
CovMat = [0.005 -0.010 0.004,
         -0.010 0.040 -0.002,
          0.004 -0.002 0.023];
NPts = 10;

[PRisk_cvx, PRoR_cvx, PWts_cvx] = NaiveMV_cvx(ExpRet, CovMat, NPts);



%% 2 plotting 

Closeplot1first = Close1(1:length(Close1)/2);
Closeplot1second = Close1(length(Close1)/2: end);
Closeplot3first = Close3(1:length(Close3)/2);
Closeplot3second = Close3(length(Close3)/2: end);
Closeplot7first = Close7(1:length(Close7)/2);
Closeplot7second = Close7(length(Close7)/2: end);

startDate = datenum('02-24-2014');
endDate = datenum('02-24-2017');
xData = linspace(startDate, endDate, 784);
xDatafirst = xData(1:length(xData)/2);
xDatasecond = xData(length(xData)/2:end);
datetick('x','mmmyyyy', 'keepticks');

plot(xDatafirst, Closeplot1first, 'red', xDatasecond, Closeplot1second, 'blue');
datetick('x','mmmyyyy', 'keepticks');

hold on 
plot(xDatafirst, Closeplot3first, 'red', xDatasecond, Closeplot3second, 'blue');

hold off

hold on 
plot(xDatafirst, Closeplot7first, 'red', xDatasecond, Closeplot7second, 'blue');

hold off


% import the data


ftse100return = stocksReturn(1, length(ftse100)-1,ftse100);
return1 = stocksReturn(1, length(Close1)-1,Close1);
return2 = stocksReturn(1, length(Close2)-1,Close2);
return3 = stocksReturn(1, length(Close3)-1,Close3);
return4 = stocksReturn(1, length(Close4)-1,Close4);
return5 = stocksReturn(1, length(Close5)-1,Close5);
return6 = stocksReturn(1, length(Close6)-1,Close6);
return7 = stocksReturn(1, length(Close7)-1,Close7);
return8 = stocksReturn(1, length(Close8)-1,Close8);
return9 = stocksReturn(1, length(Close9)-1,Close9);
return10 = stocksReturn(1, length(Close10)-1,Close10);
return11 = stocksReturn(1, length(Close11)-1,Close11);
return12 = stocksReturn(1, length(Close12)-1,Close12);
return13 = stocksReturn(1, length(Close13)-1,Close13);
return14 = stocksReturn(1, length(Close14)-1,Close14);
return15 = stocksReturn(1, length(Close15)-1,Close15);
return16 = stocksReturn(1, length(Close16)-1,Close16);
return17 = stocksReturn(1, length(Close17)-1,Close17);
return18 = stocksReturn(1, length(Close18)-1,Close18);
return19 = stocksReturn(1, length(Close19)-1,Close19);
return20 = stocksReturn(1, length(Close20)-1,Close20);
return21 = stocksReturn(1, length(Close21)-1,Close21);
return22 = stocksReturn(1, length(Close22)-1,Close22);
return23 = stocksReturn(1, length(Close23)-1,Close23);
return24 = stocksReturn(1, length(Close24)-1,Close24);
return25 = stocksReturn(1, length(Close25)-1,Close25);
return26 = stocksReturn(1, length(Close26)-1,Close26);
return27 = stocksReturn(1, length(Close27)-1,Close27);
return28 = stocksReturn(1, length(Close28)-1,Close28);
return29 = stocksReturn(1, length(Close29)-1,Close29);
return30 = stocksReturn(1, length(Close30)-1,Close30);
% choose three assets
% first half data
% three positive return 
return1_first = return1(1:length(return1)/2);
return3_first = return3(1:length(return3)/2);
return7_first = return7(1:length(return7)/2);
return_first = [return1_first return3_first return7_first];

return1_second = return1(length(return1)/2:end);
return3_second = return3(length(return3)/2:end);
return7_second = return7(length(return7)/2:end);
return_second = [return1_second return3_second return7_second];


% second half data
return_first_mean= [mean(return1_first), mean(return3_first), mean(return7_first)];
covfirst = sqrt(cov(return_first))/100;
effic_iter = 10;
p = Portfolio;
p = setAssetMoments(p, return_first_mean, covfirst);
p = setDefaultConstraints(p);

% choose only one weights / not optimal
% PortWts = estimateFrontier(p, effic_iter);
PortWts = estimateFrontier(p, effic_iter);
sharpeRTest = estimateMaxSharpeRatio(p);
sharpe_effic = sharpe(return_second,0);


% for second half data
% efficient return and cov
return_second = [return1_second, return3_second, return7_second];
cov_second = sqrt(cov(return_second))/100;
[weighted_return_second] = return_second * sharpeRTest;
[mean_return_second] = mean(weighted_return_second);
[weighted_cov_second] = sqrt(cov(weighted_return_second))/100;

mean_second_return = [mean(return1_second); mean(return3_second) ; mean(return7_second)];
estimate_cov_10_weights = zeros(10,1);
for j = 1:10
    estimate_cov_10_weights(j) = PortWts(:,j)' * cov_second * PortWts(:,j);
end
estimate_return_10_weights = PortWts'* mean_second_return;
plot(estimate_cov_10_weights, estimate_return_10_weights);


% 1 / N  naive portfolio
equallyWeights = [1/3;1/3;1/3];
naive_risk = equallyWeights' * cov_second * equallyWeights
naive_mean_return = mean(return_second*equallyWeights);
hold on 
plot(naive_risk, naive_mean_return, 'r*');

sharpe_naive = sharpe(return_second*1/3, 0);

hold off
xlim([0.03 0.20]);
text(0.07, 0.35,'Naive Strategy', 'FontSize',18);
text(0.1, 0.6, 'first half efficient portfolio', 'FontSize',18);
xlabel('Risk');
ylabel('Return');


% a fifth mimic index
returnMatrix = containers.Map;
returnMatrix('return1') = return1;
returnMatrix('return2') = return2;
returnMatrix('return3') = return3;
returnMatrix('return4') = return4;
returnMatrix('return5') = return5;
returnMatrix('return6') = return6;
returnMatrix('return7') = return7;
returnMatrix('return8') = return8;
returnMatrix('return9') = return9;
returnMatrix('return10') = return10;
returnMatrix('return11') = return11;
returnMatrix('return12') = return12;
returnMatrix('return13') = return13;
returnMatrix('return14') = return14;
returnMatrix('return15') = return15;
returnMatrix('return16') = return16;
returnMatrix('return17') = return17;
returnMatrix('return18') = return18;
returnMatrix('return19') = return19;
returnMatrix('return20') = return20;
returnMatrix('return21') = return21;
returnMatrix('return22') = return22;
returnMatrix('return23') = return23;
returnMatrix('return24') = return24;
returnMatrix('return25') = return25;
returnMatrix('return26') = return26;
returnMatrix('return27') = return27;
returnMatrix('return28') = return28;
returnMatrix('return29') = return29;
returnMatrix('return30') = return30;


x = containers.Map;
x('close1') = Close1;
x('close2') = Close2;
x('close3') = Close3;
x('close4') = Close4;
x('close5') = Close5;
x('close6') = Close6;
x('close7') = Close7;
x('close8') = Close8;
x('close9') = Close9;
x('close10') = Close10;
x('close11') = Close11;
x('close12') = Close12;
x('close13') = Close13;
x('close14') = Close14;
x('close15') = Close15;
x('close16') = Close16;
x('close17') = Close17;
x('close18') = Close18;
x('close19') = Close19;
x('close20') = Close20;
x('close21') = Close21;
x('close22') = Close22;
x('close23') = Close23;
x('close24') = Close24;
x('close25') = Close25;
x('close26') = Close26;
x('close27') = Close27;
x('close28') = Close28;
x('close29') = Close29;
x('close30') = Close30;



% ftse100
% assets = x;

assetsReturn = returnMatrix;
index_track = containers.Map;
error = inf;
asset_combi = [];
s = size(asset_combi);
index_tracking = [];
error_set = [];
while s(2) < 7
    tmp_combi = asset_combi;
    len = length(assetsReturn);
    index = keys(assetsReturn);
    for i = 1:len
        disp(i)
        asset_extract = assetsReturn(strjoin(index(i)));
        asset_combi = [tmp_combi asset_extract];
        weights = ftse100return \ asset_combi;
        esti = mean(power((ftse100return - (asset_combi*weights')),2));
        if esti < error 
            error = esti;
            iter_close = i;
        end
    end
    error_set = [error_set error];
    index_tracking = [index_tracking index(iter_close)];
    asset_combi = [tmp_combi assetsReturn(strjoin(index(iter_close)))];
    remove(assetsReturn,index(iter_close));
    s = size(asset_combi);
end
index_tracking % a fifth
number = [1 2 3 4 5 6 7];
plot(number, error_set,'b', number, error_set, 'ro');
xlim([0 7]);
ylim([0 3000]);
xlabel('number of stocks selected','FontSize',18);
ylabel('mean square error','FontSize',18);


return_combi = [return1, return2, return3, return4, return5, return6, return7, return8, return9, return10, return11, return12, return13, return14, return15, return16, return17, return18, return19, return20, return21, return22, return23, return24, return25, return26,return27,return28,return29,return30];

%% turning point 
% l1 regularization
rou = mean(ftse100return);
equal_ones = ones(1,30);
[T, N] =size(return_combi);
mu = (mean(return_combi))';
non_zero_vector = [];
lambda_vector = [];
for lambda = 0:20:1000
    disp(lambda)
    cvx_begin quiet
        variable w(N)
        minimize(norm((rou*ones(T,1) - return_combi*w),2) + lambda*norm(w,1))

        subject to
            w'*ones(N,1) == 1;
            w'* mu == rou;

    cvx_end
    non_zeros_weights = sum(abs(w) > 0.01);
    non_zero_vector = [non_zero_vector non_zeros_weights];
    lambda_vector = [lambda_vector lambda];

end


plot(lambda_vector, non_zero_vector);
xlabel('penalty tau', 'FontSize', 18);
ylabel('Non-zero weights', 'FontSize', 18);
title('l1 regularization', 'FontSize', 18)
ylim([0 25]);

hold on 
scatter(360, 7, 'ro','filled');
hold off
text(360,6, 'turning point');
