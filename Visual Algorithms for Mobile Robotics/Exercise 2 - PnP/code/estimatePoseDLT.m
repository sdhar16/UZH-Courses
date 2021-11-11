function M = estimatePoseDLT(p, P, K)
    p_cal = inv(K) * p;

    Q = zeros(size(p,2)*2, 12);

    for i=2:2:size(p,2)*2
        x = p_cal(1,i/2);
        y = p_cal(2,i/2);
        X = P(1, i/2);
        Y = P(2, i/2);
        Z = P(3, i/2);

        Q(i-1, :) =     [X Y Z 1 0 0 0 0 -x*X -x*Y -x*Z -x];
        Q(i, :) = [0 0 0 0 X Y Z 1 -y*X -y*Y -y*Z -y];
    end
    
    [~,~,V] = svd(Q);

    M = V(:,end);

    if(M(12,1)<0)
        M = -M;
    end
    
    M = reshape(M, [4,3]);
    M = transpose(M);

    disp(M);

    R = M(:,[1,2,3]);
    [U,~,V] = svd(R);
    R_dash = U*V';

    disp(det(R_dash));
    disp(R_dash*R_dash')

    alpha = norm(R_dash) / norm(R);
    t = alpha * M(:,4);
    M = [R_dash t];
end
