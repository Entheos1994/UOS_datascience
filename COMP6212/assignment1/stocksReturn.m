function [stocksRe] = stocksReturn(start, last, stocks)
    stocksRe = [];
    for d = start:last
        tmp = stocks(d+1) - stocks(d);
        stocksRe = [stocksRe; tmp];
    end
end