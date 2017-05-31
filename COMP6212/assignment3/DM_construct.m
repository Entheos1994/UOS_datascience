function[design_matrix] = DM_construct(X)
    
    


    X_1 = X(:,1);
    X_2 = X(:,2);
    GMM = fitgmdist(X,4);
    m1 = GMM.mu(1,:);
    m2 = GMM.mu(2,:);
    m3 = GMM.mu(3,:);
    m4 = GMM.mu(4,:);
    covariance = cov(X);
    rbf_vector1 = [];
    rbf_vector2 = [];
    rbf_vector3 = [];
    rbf_vector4 = [];
    
    for i = 1:length(X_1)
        rbf_1 = sqrt((X(i,:)-m1)*(covariance*(X(i,:) - m1)'));
        rbf_2 = sqrt((X(i,:)-m2)*(covariance*(X(i,:) - m2)'));
        rbf_3 = sqrt((X(i,:)-m3)*(covariance*(X(i,:) - m3)'));
        rbf_4 = sqrt((X(i,:)-m4)*(covariance*(X(i,:) - m4)'));

        rbf_vector1 = [rbf_vector1 rbf_1];
        rbf_vector2 = [rbf_vector2 rbf_2];
        rbf_vector3 = [rbf_vector3 rbf_3];
        rbf_vector4 = [rbf_vector4 rbf_4];

    end
        
    cons = ones(length(X),1);

    design_matrix = [rbf_vector1' rbf_vector2' rbf_vector3' rbf_vector4' X_1 X_2 cons];


end
