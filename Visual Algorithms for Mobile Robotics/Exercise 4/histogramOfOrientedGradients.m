function hog = histogramOfOrientedGradients(keypoints, gaussian_blur, num_octave, num_scales)
    assert(num_octaves == numel(kpt_locations));
    assert(num_octave==numel(blurred_images));
    descriptors = {};
    final_kpt_locations = {};

    gausswindow = fspecial('gaussian', [16, 16], 16 * 1.5);

    for o=1:num_octave
        octave_blurred_images = gaussian_blur{o};
        octave_keypoints = keypoints{o};
        
        sort_keypoints = unique(octave_keypoints(:,3));
        

        for kp=sort_keypoints'
            image = octave_blurred_images(kp,:,:);
            [rows_img, cols_img] = size(curr_image );
            [mag, dir] = imgradient(image);
            is_kpts = sort_keypoints(:, 3) == kp;
            kpts_locations = octave_keypoints(is_kpts,:);
            kpts_locations = kpts_locations(:, 1:2);
            
            num_kpts = size(kpt_locations,1);

            img_descriptors = zeros(num_kpts, 128);
            is_valid = false(num_kpts, 1);
            for kpts=1:num_kpts
                kp_x = kpts_locations(kpts, 1);
                kp_y = kpts_locations(kpts, 2);
                
               if(kp_x>8 && kp_y>7 && kp_x<rows_img-8 && kp_y<cols_img-7)
                   is_valid(kpts) = true;
                    

               end
            end


        end
    end
    


end