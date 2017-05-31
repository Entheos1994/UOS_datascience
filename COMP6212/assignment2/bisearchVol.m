function [vol] = bisearchVol(stock_price, strike_price, risk_free, t, call_price)
    % init
    % upper bound
    % lower bound
    esti_price = 0;
    % binary search
    vol = 2;
    upper = 3;
    lower = 0;
    Call_mid = 0;
    while abs(esti_price - call_price) > 1e-3
        v_mid = (upper + lower) / 2;
        % [Call_upper, Put] = blsprice(stock_price,strike_price, risk_free, t, upper);
        % [Call_lower, Put] = blsprice(stock_price,strike_price, risk_free, t, lower);
        [call, put] = blsprice(stock_price, strike_price, risk_free, t, v_mid);
        
        if call - call_price > 0
            upper = v_mid;
        end
        if call - call_price <0
            lower = v_mid;
        esti_price = call;
        end
        disp(call)
        disp(105)
        disp(upper)
        disp(lower)
        
    end

    vol = (upper + lower) / 2;

end

