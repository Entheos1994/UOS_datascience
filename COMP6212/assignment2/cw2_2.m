% import data
load('workbook.mat')

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


% price 
price_esti = price(end-length(price)/4:end);
% estimate call and  option
call_vector = [];
put_vector = [];
for day = 1:length(price_esti)
    [Call, Put] = blsprice(price_esti(day), 2925, 0.06, (57-day)/222, esti_vector(day));
    call_vector = [call_vector; Call];
    put_vector = [put_vector; Put];
end

origin_call = call_option_2925(end-length(call_option_2925)/4:end);
origin_put = put_option_2925(end-length(put_option_2925)/4:end);


[origin_call call_vector];

% 1/4 date 
figure(1);
date_quarter = date(end-length(date)/4:end);
plot(date_quarter, call_vector);
hold on 
plot(date_quarter, origin_call,'r');
title('Call Option Estimate')
hold off 
datetick('x','mm/dd', 'keepticks');

xlabel('Date');
ylabel('call option price');
legend('estimate option', 'actual option');

% sliding window for 1/4 length
figure(2);
date_quarter = date(end-length(date)/4:end);
plot(date_quarter, put_vector);
hold on 
plot(date_quarter, origin_put,'r');
title('Put Option Estimate')
hold off 
datetick('x','mm/dd', 'keepticks');

xlabel('Date');
ylabel('put option price');
legend('estimate option', 'actual option');
