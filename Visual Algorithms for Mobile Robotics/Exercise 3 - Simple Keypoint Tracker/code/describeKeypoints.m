function descriptors = describeKeypoints(img, keypoints, r)
% Returns a (2r+1)^2xN matrix of image patch vectors based on image
% img and a 2xN matrix containing the keypoint coordinates.
% r is the patch "radius".
    descriptors = zeros((2*r+1)^2, size(keypoints,2));
    disp(size(img))
    img = padarray(img, [r,r]);

    disp(size(img));
    for i = 1:size(keypoints,2)
        x = keypoints(1,i);
        y = keypoints(2,i);

        descriptors(:, i) = reshape(img(x:x+2*r, y:y+2*r), [],1);
    end
