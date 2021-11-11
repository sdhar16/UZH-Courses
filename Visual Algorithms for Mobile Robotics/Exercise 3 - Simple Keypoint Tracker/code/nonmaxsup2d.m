function imgResult = nonmaxsup2d(imgHough, r)
    imgResult = zeros(size(imgHough));

    for y = 1+r:size(imgHough, 1)-r
        for x = 1+r:size(imgHough, 2)-r
            patch = imgHough(y-r:y+r, x-r:x+r);
            center = patch(r,r);
            patch(r,r) = 0;
            maxVal = max(reshape(patch, [],1));
            if(center>maxVal)
                imgResult(y,x) = imgHough(y,x);
            end

        end
    end
    
end