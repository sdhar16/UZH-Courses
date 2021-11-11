function keypoints = selectKeypoints(DoG, num_octave, num_scales, contrast_threshold)
    % Apply threshold of C = 0.04

    nms = {};
    nms{num_octave} = [];
    for o=1:num_octave
        DoG{o}(DoG{o}<contrast_threshold) = 0;

        current_octave = DoG{o};
        octave_scales = zeros(num_scales, size(current_octave,2), size(current_octave,3));
        
        pad = 1;
        for s=2:num_scales+1
           upper = current_octave(s+1,:,:);
           lower = current_octave(s-1,:,:);
           mid = current_octave(s,:,:);

           temp_mid = padarray(squeeze(mid), [pad pad]);
           temp_upper = padarray(squeeze(upper), [pad pad]);
           temp_lower = padarray(squeeze(lower), [pad pad]);

           final = zeros(size(mid,2), size(mid,3));
           while(1)
               [m, kp] = max(temp_mid(:));
               if(m==0)
                   break;
               end
               [row, col] = ind2sub(size(temp_mid), kp);
               kp = [row;col];
               upper_patch = temp_upper(kp(1)-pad:kp(1)+pad, kp(2)-pad:kp(2)+pad);
               lower_patch = temp_lower(kp(1)-pad:kp(1)+pad, kp(2)-pad:kp(2)+pad);

               if(m<max(upper_patch(:)) || m<max(lower_patch(:)))
                   temp_mid(kp(1)-pad:kp(1)+pad, kp(2)-pad:kp(2)+pad) = zeros(2*pad + 1, 2*pad + 1);
                   continue;
               end
               
               final(row, col) = temp_mid(row, col);
               temp_mid(kp(1)-pad:kp(1)+pad, kp(2)-pad:kp(2)+pad) = zeros(2*pad + 1, 2*pad + 1);
           end
           
           octave_scales(s-1,:,:) = final;
           
        end

        is_kpt = octave_scales>0;

        [s,x,y] = ind2sub(size(is_kpt), find(is_kpt));
        nms{o} = horzcat(x,y,s);
    end
    keypoints = nms;
end