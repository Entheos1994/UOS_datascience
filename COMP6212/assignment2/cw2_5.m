%% put option estimated with binomial trees
put_vector = put_option_2925(end-length(put_option_2925)/4:end);

T = 56/222;
k = 2925;
s0 = 3022.5;
N = 1;
r = 0.06;
binomial_put_vector = [];

for day = 1:length(esti_vector)
    binomial_put = AmPutLattice(price_esti(day), k, r, (T_days-day)/222, esti_vector(day), N);
    binomial_put_vector = [binomial_put_vector; binomial_put];
end

figure(1);
date_quarter = date(end-length(date)/4:end);
plot(date_quarter, put_vector);
hold on 
plot(date_quarter, binomial_put_vector,'r');
title('put Option Estimate')
hold off 
datetick('x','mm/dd', 'keepticks');

xlabel('Date');
ylabel('put option price');
legend('put option', 'binomial-tree option');