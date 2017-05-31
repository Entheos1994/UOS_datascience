function[PRisk_cvx, PRoR_cvx, PWts_cvx] = NaiveMV_cvx(ERet, ECov, NPts)
ERet = ERet(:); % the vector of expected return 
NAssets = length(ERet); % the number of assets
V0 = zeros(NAssets, 1); % vector of lower bounds on weights
V1 = ones(1, NAssets); % equality constraints  weights should add up to 1

% options = optimset('LargeScale', 'off'); % scale option
% MaxReturnWeights = linprog(-ERet, [], [], V1, 1, V0); % find the max return weight
cvx_begin
    variable MaxReturnWeights(NAssets)
    maximize(MaxReturnWeights'*ERet)
    subject to
        MaxReturnWeights >= 0;
        sum(MaxReturnWeights) == 1;
cvx_end
MaxReturn = MaxReturnWeights' * ERet; % find the max return


%MinVarWeights = quadprog(ECov, V0, [], [], V1, 1, V0, [], [], options); % find the minimum variance return weights

cvx_begin
    variable MinVarWeights(NAssets)
    minimize(MinVarWeights'*ECov*MinVarWeights)
    subject to
        MinVarWeights >= 0;
        sum(MinVarWeights) == 1;
cvx_end

MinVarReturn = MinVarWeights' * ERet; % find the minimum variance  return
MinVarStd = sqrt(MinVarWeights' * ECov * MinVarWeights); % find the minimum standard deviation

if MaxReturn > MinVarReturn % check if there is only one efficient portfolio
   RTarget = linspace(MinVarReturn, MaxReturn, NPts);
   NumFrontPoints = NPts;
else
    RTarget = MaxReturn;
    NumFrontPoints = 1;
end

% initlize output
PRoR_cvx = zeros(NumFrontPoints, 1); % the rate of return
PRisk_cvx = zeros(NumFrontPoints, 1); % the risk(standard deviation of return)
PWts_cvx = zeros(NumFrontPoints, NAssets); % the matrix portfolio weights

% first portfolio
PRoR_cvx(1) = MinVarReturn; 
PRisk_cvx(1) = MinVarStd;
PWts_cvx(1,:) = MinVarWeights(:)';

% trace frontier by changing target return
VConstr = ERet';
A = [V1 ; VConstr];
B = [1 ; 0];

for point= 2:NumFrontPoints
    B(2) = RTarget(point);
    
    % Weights = quadprog(ECov, V0, [], [], A, B, V0, [], [], options);
    cvx_begin
    variable Weights(NAssets)
    minimize(Weights'*ECov*Weights)
    subject to
        Weights'*ERet == B(2);
        sum(Weights) == 1;
        Weights >= 0;
    cvx_end

    PRoR_cvx(point) = dot(Weights, ERet);
    PRisk_cvx(point) = sqrt(Weights'*ECov*Weights);
    PWts_cvx(point, :) = Weights(:)';
end





end
