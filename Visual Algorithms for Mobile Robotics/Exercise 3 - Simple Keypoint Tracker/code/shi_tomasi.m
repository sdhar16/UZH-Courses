function scores = shi_tomasi(img, patch_size)
    [h,w] = size(img);
    sobel_X = [-1, 0, 1;
        -2,0,2;
        -1,0,1];
    sobel_Y = [-1, -2, -1;
        0, 0 ,0;
        1, 2, 1];

    img_x = conv2(double(img), sobel_X, 'valid');
    img_y = conv2(double(img), sobel_Y, 'valid');
    
    patch_filter = ones(patch_size, patch_size);

    img_x_sum = conv2(img_x .^ 2, patch_filter, 'valid');
    img_y_sum = conv2(img_y .^ 2, patch_filter, 'valid');
    img_xy_sum = conv2(img_x .* img_y, patch_filter, 'valid');
    

    R = zeros(h - 1 - patch_size , w - 1 - patch_size);
    
    for u=1:h - 1 - patch_size
        for v=1:w - 1 - patch_size
            M = [img_x_sum(u,v), img_xy_sum(u,v);
                img_xy_sum(u,v), img_y_sum(u,v)];

            [~,S,~] = svd(M);
            R(u,v) = min(S(1,1), S(2,2));
        end
    end
    R = padarray(R, [(1+patch_size)/2, (1+patch_size)/2]);

    R(R<0) = 0;    
    scores = R;
    
end
