
n = 173;
vola_price = price(n-30:n);
sub_call_option = call_option_2925(n-30:n);

%% daily return
dailyreturn = [];
for p = 1:length(price)-1
    dailyreturn = [dailyreturn; price(p+1)-price(p)];
end


%% estimated variance vector
esti_vector = [];
for j = length(dailyreturn)-173:length(dailyreturn)-143
    standard = (sqrt(var(dailyreturn(j:j+30)))/100)* sqrt(30/222);
    esti_vector = [esti_vector;standard];
end

%% implied variance vector
implied_vector = [];
for i = 1:length(vola_price)
    implied_var = blsimpv(vola_price(i), 2925, 0.06, (252-173-i)/252, sub_call_option(i));
    implied_vector = [implied_vector; implied_var];
end

scatter(esti_vector, implied_vector, 'red','filled');
xlabel('Estimated variance')
ylabel('Implied variance')
title('implied vs. Estimated')
xlim([0 0.4]);
ylim([0 0.4]);

%% volatility smile
option_call_price = [274, 205, 148, 80, 80];
strike_price =[3025, 3075, 3125, 3175, 3225];
implied_smile = [];

for j = 1:length(strike_price)
    implied_var = blsimpv(3126, strike_price(j), 0.06, (222-76)/222, option_call_price(j));
    implied_smile = [implied_smile; implied_var];
end

plot(strike_price, implied_smile, 'red');
y1=get(gca,'ylim')

hold on 
plot([3126 3126],y1)

hold off

xlabel('strike price');
ylabel('implied volatility');
title('volatility smile')



