%% Import data from text file.
load('workbook.mat')
strike_price_2925 = 2925;

%% daily return

dailyreturn = [];
for p = 1:length(price)-1
    dailyreturn = [dailyreturn; price(p+1)-price(p)];
end


%% estimate volatility
esti_vector = [];
for j = 1:length(dailyreturn)-55
    standard = (sqrt(var(dailyreturn(j:j+55)))/100) *(sqrt((167-j)/222));
    esti_vector = [esti_vector;standard];
end


%% price estimate
price_esti = price((length(price)/4)+1:end);
call_vector = [];
for day = 1:length(price_esti)
    [Call] = blsprice(price_esti(day), 2925, 0.06, (166-day)/222, esti_vector(day));
    call_vector = [call_vector; Call];
end
normalized_call = call_vector / strike_price_2925;


%% construct data for RBF model
normalized_price = price_esti/strike_price_2925;
time = [166:-1:1]';
time_to_maturity = time / 222;
X = [normalized_price time_to_maturity];
GMM = fitgmdist(X,4);
covariance = cov(X);
mu = GMM.mu;
proportion = GMM.ComponentProportion;


X_t = X';
lambda_1 = proportion(1);
mean_1 = mu(1, :);

lambda_2 = proportion(2);
mean_2 = mu(2, :);

lambda_3 = proportion(3);
mean_3 = mu(3, :);

lambda_4 = proportion(4);
mean_4 = mu(4, :);

rbf_1 = [];
rbf_2 = [];
rbf_3 = [];
rbf_4 = [];

for i = 1:length(X_t)
    one = ((X_t(:,i) - mean_1')'*covariance*(X_t(:,i) - mean_1'))^(1/2);
    two = ((X_t(:,i) - mean_2')'*covariance*(X_t(:,i) - mean_2'))^(1/2);
    three = ((X_t(:,i) - mean_3')'*covariance*(X_t(:,i) - mean_3'))^(1/2);
    four = ((X_t(:,i) - mean_4')'*covariance*(X_t(:,i) - mean_4'))^(1/2);
    rbf_1 = [rbf_1; one];
    rbf_2 = [rbf_2; two];
    rbf_3 = [rbf_3; three];
    rbf_4 = [rbf_4; four];
end

cons = ones(166,1);
design_m = [rbf_1 rbf_2 rbf_3 rbf_4 X(:,1) X(:,2) cons];

params = design_m \ normalized_call;
estimate_price =  design_m * params;


%% plot 
X_1 = X(:,1);
X_2 = X(:,2);

x_array = linspace(min(X_1), max(X_1), 50);
y_array = linspace(min(X_2), max(X_2), 50);
[X_plot, Y_plot] = meshgrid(x_array, y_array);
Z_plot = griddata(X_1, X_2, estimate_price/strike_price_2925, X_plot, Y_plot);
surf(X_plot, Y_plot, Z_plot);

[X_plot, Y_plot] = meshgrid(X_1(1:4:end), X(1:4:end));
normalized_estimate = estimate_price / strike_price_2925;
Z_plot = griddata(X(:,1), X(:,2), estimate_price, X_plot, Y_plot);
hold on 
scatter3(X_1(1:3:end), X_2(1:3:end), normalized_estimate(1:3:end), 'filled', 'black');
hold off
xlabel('S/X');
ylabel('T-t');
zlabel('C/X');
title('3D normalized call option price estimate')
    

%% linear estimation vs. bls estimation
figure(2);
date_quarter = date((length(date)/4) + 1:end);
plot(date_quarter, normalized_call);
hold on 
plot(date_quarter, estimate_price,'r');
title('Call Option Estimate')
hold off 
datetick('x','mm/dd', 'keepticks');

xlabel('Date');
ylabel('call option price');
legend('bls option', 'learning networks');



%% delta 
delta_vector = [];
for i = 1:length(X)
    current_point = X(i,:);
    derivative_11 = covariance * ((current_point - mean_1)');
    derivative_12 = (current_point - mean_1)*covariance*((current_point-mean_1)');
    derivative_13 = (1/sqrt(derivative_12)) * params(1) * derivative_11;

    derivative_21 = covariance * ((current_point - mean_2)');
    derivative_22 = (current_point - mean_2)*covariance*((current_point-mean_2)');
    derivative_23 = (1/sqrt(derivative_22)) * params(2) * derivative_21;

    derivative_31 = covariance * ((current_point - mean_3)');
    derivative_32 = (current_point - mean_3)*covariance*((current_point-mean_3)');
    derivative_33 = (1/sqrt(derivative_32)) * params(3) * derivative_31;

    derivative_41 = covariance * ((current_point - mean_4)');
    derivative_42 = (current_point - mean_4)*covariance*((current_point-mean_4)');
    derivative_43 = (1/sqrt(derivative_42)) * params(4) * derivative_41;
    delta = derivative_13(1) + derivative_23(1) + derivative_33(1) + derivative_43(1) + params(5);
    delta_vector = [delta_vector; delta];
end


%% plot 
Z_plot = griddata(X_1, X_2, delta_vector, X_plot, Y_plot);
figure(3);
scatter3(X(:,1), X(:,2), delta_vector, 'filled', 'black');
hold on
surf(X_plot,Y_plot, Z_plot)
hold off


%% call price error 
call_price_error =  estimate_price - normalized_call;


Z_plot = griddata(X_1, X_2, call_price_error, X_plot, Y_plot);

surf(X_plot,Y_plot, Z_plot)
hold on 
scatter3(X_1, X_2, call_price_error, 'filled', 'black')

hold off
xlabel('S/X')
ylabel('T-t')
zlabel('call price error')
title('Networks BLS option error')


%% delta error 
call_vector = [];
bls_call_delta = [];
for day = 1:length(price_esti)
    [call_delta, putdelta] = blsdelta(price_esti(day), 2925, 0.06, (167-day)/222, esti_vector(day), 0);
    bls_call_delta = [bls_call_delta; call_delta];
end

delta_error = delta_vector - bls_call_delta;
X_1 = X(:,1);
X_2 = X(:,2);
x_array = linspace(min(X_1),max(X_1), 30);
y_array = linspace(min(X_2),max(X_2), 30);

[X_plot, Y_plot] = meshgrid(x_array, y_array);
Z_plot = griddata(X_1, X_2, delta_error, X_plot, Y_plot);

% surf(X_plot,Y_plot, Z_plot, 'FaceColor','white','EdgeColor','blue', 'LineWidth',.5)

surf(X_plot,Y_plot, Z_plot)
hold on 
scatter3(X(:,1), X(:,2), delta_error, 'filled', 'black');
hold off
xlabel('S/X')
ylabel('T-t')
zlabel('Delta error')
title('Networks BLS Delta Error')
