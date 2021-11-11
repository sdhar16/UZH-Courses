function disp_img = getDisparity(...
    left_img, right_img, patch_radius, min_disp, max_disp)
% left_img and right_img are both H x W and you should return a H x W
% matrix containing the disparity d for each pixel of left_img. Set
% disp_img to 0 for pixels where the SSD and/or d is not defined, and for d
% estimates rejected in Part 2. patch_radius specifies the SSD patch and
% each valid d should satisfy min_disp <= d <= max_disp.
    patch_size = 2*patch_radius + 1;
    [lrow, lcol] = size(left_img);
    [~, rcol] = size(right_img);

    temp_disp_img = zeros(size(left_img, 1), size(left_img, 2));
    d = 2;


    range_col = 1+patch_radius: lcol - patch_radius;

    
    parfor row=1 + patch_radius:lrow - patch_radius
        for col=range_col
            if(col - max_disp>patch_radius)
                patch = reshape(single(left_img(row - patch_radius: row + patch_radius,col - patch_radius:col+patch_radius)), [], 1)';
    
                rstrip = inf(patch_size*patch_size, max_disp - min_disp - 1);
                rstrip(:,col:end) = 0;
                
                for rpatch_i=col-max_disp+1:col-min_disp-1
                    rpatch = single(right_img(row - patch_radius:row+patch_radius, rpatch_i - patch_radius:rpatch_i+patch_radius));
                    rstrip(:, col - rpatch_i) = reshape(rpatch, [], 1);
                end
                
                rstrip = single(rstrip)';
    
                D = pdist2(patch, rstrip, 'squaredeuclidean');
    
                [order, argmin] = sort(D);
    
                mins = order(1);

                maxmin = 1.5*mins;
                
                hasoutliers = ~(sum(order<maxmin) <= (d+1));
                
                disparity = argmin(1);
                    
                if(hasoutliers || disparity<min_disp || disparity>max_disp) 
                    disparity = 0;
                end
    
                temp_disp_img(row, col) = disparity;
            end
        end
    end
    
    disp_img = temp_disp_img;
    disp_img(:,1:patch_radius+max_disp) = 0; 
end
