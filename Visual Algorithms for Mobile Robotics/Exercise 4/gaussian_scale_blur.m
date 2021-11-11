function gaussian_blur = gaussian_scale_blur(img, num_scales, num_octave, sigma0)
    gaussian_blur = {};
    gaussian_blur{num_octave} = [];
    for o=1:num_octave
        down_img = imresize(img, 1/2^(o-1), 'bilinear');
        octave_blur = zeros(num_scales+3, size(down_img, 1), size(down_img, 2));
        for s = -1:num_scales+1
            disp(s)
            sigma = 2^(s/num_scales) * sigma0;
            imgBlur = imgaussfilt(down_img, sigma);
            octave_blur(s+2, :,:) = imgBlur;
        end
        gaussian_blur{o} = octave_blur;
    end
end