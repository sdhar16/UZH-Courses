function [points, intensities] = disparityToPointCloud(...
    disp_img, K, baseline, left_img)
% points should be 3xN and intensities 1xN, where N is the amount of pixels
% which have a valid disparity. I.e., only return points and intensities
% for pixels of left_img which have a valid disparity estimate! The i-th
% intensity should correspond to the i-th point.
    [lrow, lcol] = size(left_img);
    [disprow, dispcol] = size(disp_img);
    K_1 = inv(K);

    points = [];
    intensities = [];

    for row=1:lrow
        for col=1:lcol
            if(disp_img(row,col)>0)
                p0 = [col; row; 1];
                p1 = double([ col - disp_img(row, col); row ;1]);
                b = [baseline ; 0 ; 0];
                A = [K_1*p0, -K_1*p1];
                lambda = lsqminnorm(A,b);

                lambda0 = lambda(1);
                P =  lambda0 * K_1 * p0;

                points = [points, P];
                intensities = [intensities, left_img(row, col)];
            end
        end
    end
    