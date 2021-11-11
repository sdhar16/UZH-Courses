clear;
close all;
clc;

image = imread("..\data\images_undistorted\img_0001.jpg");

P_W = transpose(readmatrix("..\data\p_W_corners.txt"))/100;
K = readmatrix("..\data\K.txt");
p_W = readmatrix("..\data\detected_corners.txt");

p = [];

for i=2:2:size(p_W,2)
     p = [p [reshape(p_W(1,i-1:i),[2,1]) ;1]];
end

M = estimatePoseDLT(p, P_W, K);

[p_reprojected] = reprojectPoints(P_W, M,K);

image = insertMarker(image, transpose(p([1 2], :)));
image = insertMarker(image, transpose(p_reprojected([1 2], :)), 'o', 'color', 'red');
imshow(image)


transl = [];
quantl = [];
for n=2:size(p_W,1)
    p = []; 
    for i=2:2:size(p_W,2)
         p = [p [reshape(p_W(n,i-1:i),[2,1]) ;1]];
    end
    M = estimatePoseDLT(p, P_W, K);

    R_C_W = M(1:3, 1:3);
    t_C_W = M(:,4);

    rotMat = R_C_W';
    trans = -rotMat * t_C_W;
    
    transl = [transl trans];
    quantl = [quantl rotMatrix2Quat(rotMat)];
end

plotTrajectory3D(30, transl, quantl, P_W);




