% import data
% calculate 
% date / call_option / price
dailyreturn = [];
for p = 1:length(price)-1
    dailyreturn = [dailyreturn; price(p+1)-price(p)];
end

%  1/4 variance 

esti_standard = sqrt(var(dailyreturn(length(dailyreturn)-56:length(dailyreturn))))/100;
esti_final = esti_standard * sqrt(56/365);


esti_vector = [];
for j = length(dailyreturn)-110:length(dailyreturn)-55
    standard = (sqrt(var(dailyreturn(j:j+55)))/100) *(sqrt(56/222));
    esti_vector = [esti_vector;standard];
end

price_esti = price(end-length(price)/4:end);
% estimate call and put option
call_vector = [];
put_vector = [];
for day = 1:length(price_esti)
    [Call, Put] = blsprice(price_esti(day), 2925, 0.06, (57-day)/222, esti_vector(day));
    call_vector = [call_vector; Call];
    put_vector = [put_vector; Put];
end

T_days = 57;
r = 0.06;
k = 2925;
s0 = 3022.5;
N = 1;
T = 0.2;

binomial_vector = [];
for day = 1:length(esti_vector)
    binomial_call = LatticeEurCall(price_esti(day), k, r, (T_days-day)/222, esti_vector(day), N);
    binomial_vector = [binomial_vector; binomial_call];
end

[origin_call call_vector];

% 1/4 date estimate
figure(1);
date_quarter = date(end-length(date)/4:end);
plot(date_quarter, call_vector);
hold on 
plot(date_quarter, binomial_vector,'r');
title('Call Option Estimate')
hold off 
datetick('x','mm/dd', 'keepticks');

xlabel('Date');
ylabel('call option price');
legend('bls option', 'binomial-tree option');

%% different time steps from 1 to 20 
% binomial tree vs. bls 
% as steps going up, two methods converge
T = 56/222;
k = 2925;
s0 = 3022.5;
N = linspace(1,20,20);
r = 0.06;

binomial_n = [];
diffs = [];

for n = 1:length(N)
   [option_price, lats] = LatticeEurCall(s0, k, r, T, esti_vector(1), n);
   disp(lats);
   binomial_n = [binomial_n; option_price];
   diffs = [diffs; call_vector(1)-option_price];
end

diffs = abs(diffs);
plot(diffs);
xlabel('time steps N');
ylabel('Call option difference');
title('Binomial-tree vs. Black-scholes')


















