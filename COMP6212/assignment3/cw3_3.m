%% import data
load('workbook.mat')



%% training 
strike_2925 = 2925;
strike_3025 = 3025;
strike_3125 = 3125;
strike_3225 = 3225;
strike_3325 = 3325;


train_time = [222:-1:57]';
test_time = [56:-1:1]';

train_to_maturity = train_time / 222;
test_to_maturity = test_time / 222;
time_to_maturity = [222:-1:1];
time_to_maturity = time_to_maturity / 222;

train_option_2925 = call_option_2925(1:166);
train_2925_normalized = train_option_2925 / strike_2925;
test_option_2925 = call_option_2925(167:end);
test_2925_normalized = test_option_2925 / strike_2925;

train_option_3025 = call_option_3025(1:166);
train_3025_normalized = train_option_3025 / strike_3025;
test_option_3025 = call_option_3025(167:end);
test_3025_normalized = test_option_3025 / strike_3025;

train_option_3125 = call_option_3125(1:166);
train_3125_normalized = train_option_3125 / strike_3125;
test_option_3125 = call_option_3125(167:end);
test_3125_normalized = test_option_3125 / strike_3125;

train_option_3225 = call_option_3225(1:166);
train_3225_normalized = train_option_3225 / strike_3225;
test_option_3225 = call_option_3225(167:end);
test_3225_normalized = test_option_3225 / strike_3225;

train_option_3325 = call_option_3325(1:166);
train_3325_normalized = train_option_3325 / strike_3325;
test_option_3325 = call_option_3325(167:end);
test_3325_normalized = test_option_3325 / strike_3325;

normalized_2925 = price / strike_2925;
normalized_3025 = price / strike_3025;
normalized_3125 = price / strike_3125;
normalized_3225 = price / strike_3225;
normalized_3325 = price / strike_3325;



train_price_2925 = normalized_2925(1:166);
test_price_2925 = normalized_2925(167:end);

train_price_3025 = normalized_3025(1:166);
test_price_3025 = normalized_3025(167:end);

train_price_3125 = normalized_3125(1:166);
test_price_3125 = normalized_3125(167:end);

train_price_3225 = normalized_3225(1:166);
test_price_3225 = normalized_3225(167:end);

train_price_3325 = normalized_3325(1:166);
test_price_3325 = normalized_3325(167:end);


train_2925 = [train_price_2925 train_to_maturity];
test_2925 = [test_price_2925 test_to_maturity];

train_3025 = [train_price_3025 train_to_maturity];
test_3025 = [test_price_3025 test_to_maturity];

train_3125 = [train_price_3125 train_to_maturity];
test_3125 = [test_price_3125 test_to_maturity];

train_3225 = [train_price_3225 train_to_maturity];
test_3225 = [test_price_3225 test_to_maturity];

train_3325 = [train_price_3325 train_to_maturity];
test_3325 = [test_price_3325 test_to_maturity];


dm_train_2925 = DM_construct(train_2925);
dm_test_2925 = DM_construct(test_2925);


dm_2925 = DM_construct([normalized_2925 time_to_maturity']);
dm_2925_train = dm_2925(1:166,:);
dm_2925_test = dm_2925(167:end,:);



params_1_2925 = dm_2925_train \ train_option_2925;
train_2925_new_pred = dm_2925_train * params_1_2925;
test_2925_new_pred = dm_2925_test * params_1_2925;



%% plot
figure(1);
date_first = date(1:166);
plot(date_first, train_2925_new_pred);
hold on 
plot(date_first, train_option_2925,'r');
title('Learning networks Call Option Estimate')
hold off 
datetick('x','mm/dd', 'keepticks');

xlabel('Date');
ylabel('call option price');
legend('train estimate', 'train option');

figure(2);
date_second = date(167:end);
plot(date_second, test_2925_new_pred);
hold on 
plot(date_second, test_option_2925,'r');
title('testset Option Estimate')
hold off 
datetick('x','mm/dd', 'keepticks');

xlabel('Date');
ylabel('call option price');
legend('test estimate', 'test option');



dm_train_3025 = DM_construct(train_3025);
dm_test_3025 = DM_construct(test_3025);

dm_train_3125 = DM_construct(train_3125);
dm_test_3125 = DM_construct(test_3125);

dm_train_3225 = DM_construct(train_3225);
dm_test_3225 = DM_construct(test_3225);

dm_train_3325 = DM_construct(train_3325);
dm_test_3325 = DM_construct(test_3325);


%% linear 1 
params_1 = dm_train_2925 \ train_2925_normalized;
r_1 = R_square(params_1, dm_test_2925, test_2925_normalized, train_2925_normalized)
params_1_test = dm_train_2925 \ train_option_2925;
train_2925_predict = dm_train_2925 * params_1_test;

test_2925_predict = dm_test_2925 * params_1_test;
r_1_test = R_square(params_1_test, dm_test_2925, test_option_2925, train_option_2925)
r_1 = 0.5473;
r_1_test = 0.6357;

%% train data estimate
figure(1);
date_first = date(1:166);
plot(date_first, train_2925_predict);
hold on 
plot(date_first, train_option_2925,'r');
title('Learning networks Call Option Estimate')
hold off 
datetick('x','mm/dd', 'keepticks');

xlabel('Date');
ylabel('call option price');
legend('train estimate', 'train option');

%% test data estimate
figure(2);
date_second = date(167:end);
plot(date_second, test_2925_predict);
hold on 
plot(date_second, test_option_2925,'r');
title('testset Option Estimate')
hold off 
datetick('x','mm/dd', 'keepticks');

xlabel('Date');
ylabel('call option price');
legend('test estimate', 'test option');


