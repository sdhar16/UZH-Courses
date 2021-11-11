function [p_reprojected] = reprojectPoints(P, M, K)
    P = [P; ones(1,size(P, 2))];

    p_reprojected = K*M*P;

    for i=1:size(P,2)
        p_reprojected(:,i) = p_reprojected(:, i) / p_reprojected(3, i);
    end
    
end