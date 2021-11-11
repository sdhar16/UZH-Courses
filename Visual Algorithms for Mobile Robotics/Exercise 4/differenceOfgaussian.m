function DoG = differenceOfgaussian(gaussian_blur, num_octave, num_scale)
    DoG = {};
    DoG{num_octave} = [];
    for o=1:num_octave
        gaussians = gaussian_blur{o};
        difference = zeros(num_scale+2, size(gaussians,2), size(gaussians,3));
        for s=2:num_scale+3
            difference(s-1,:,:) = gaussians(s,:,:) - gaussians(s-1,:,:);
        end
        DoG{o}= difference;
    end
end