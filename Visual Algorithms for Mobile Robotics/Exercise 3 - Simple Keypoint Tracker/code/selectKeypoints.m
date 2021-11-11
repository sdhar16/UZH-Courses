function keypoints = selectKeypoints(scores, num, r)
% Selects the num best scores as keypoints and performs non-maximum 
% supression of a (2r + 1)*(2r + 1) box around the current maximum.


    imgResult = nonmaxsup2d(scores, r);

    [ ~, Ind ] = sort(imgResult(:),1,'descend');
    [ ind_row, ind_col ] = ind2sub(size(imgResult),Ind(1:num)); % fetch indices

    keypoints = cat(2, ind_row, ind_col)';
end
