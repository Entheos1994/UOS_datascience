function [trans_m, trans_c, PortRisk, PortReturn] = portfolio_comb(m, c, port_size, effic_iter)
    l = length(m);
    init_w = rand(port_size, l);
    modified_w = [];
    % transform mean
    for i = 1:port_size
        tmp_w = init_w(i,:) / sum(init_w(i,:)); 
        modified_w = [modified_w;tmp_w];
    end
    
    trans_m = modified_w * m';
    
    % transform variance (standard deviation)
    trans_c = []
    for j = 1:port_size
        tmp_c = modified_w(j,:) * c * modified_w(j,:)';
        trans_c = [trans_c;tmp_c];
    end
    trans_c = power(trans_c, 0.5);
    scatter(trans_c, trans_m, 'filled', 'r');
    xlim([0 0.2])
    ylim([0.10 0.21])
        
    % efficient portfolio
    p = Portfolio;
    p = setAssetMoments(p, m, c);
    p = setDefaultConstraints(p);
    
    PortWts = estimateFrontier(p, effic_iter);
    [PortRisk, PortReturn] = estimatePortMoments(p, PortWts);
    hold on
    plotFrontier(p, effic_iter);
    hold off
    
end

