function [ theta,P, e, esti] = kalman_filter( ts, alpha )
    N = size(ts, 1);
    m = ar(ts, 2);
    R = m.NoiseVariance;

    thetas = zeros(N, 2);
    theta = (m.a(2:3) * -1)';
    P = ones(2, 2);
    Q = alpha * eye(2);
    e = zeros(N, 1);
    esti = zeros(N, 1);

    for n = 3:N
        P = P + Q;
        x = ts((n - 2):(n - 1));
        e(n) = ts(n) - theta' * x;
        esti(n) = theta'* x;
        K = (P * x) / (R + x' * P * x);
        theta = theta + K * e(n);
        thetas(n, :) = theta;
        P = (eye(2) - K * x') * P;
    end
    
     figure;
     plot(thetas(3:N, :));
     title('Estimated value of \theta over time');
     xlabel('n');
     legend('\theta_1', '\theta_2');
end
