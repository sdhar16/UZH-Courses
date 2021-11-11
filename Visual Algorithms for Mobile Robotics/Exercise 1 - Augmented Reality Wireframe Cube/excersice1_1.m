clear;
%clearall;
format longg;
image = imread("data/images_undistorted/img_0001.jpg");
image1 = rgb2gray(image);

X = (0:4:32)/100;
Y = (0:4:20)/100;
Z = zeros(1);

[imagePoints,boardSize] = detectCheckerboardPoints(image1);
markers = projectPoints(X,Y,Z,1);
J2 = insertMarker(image,transpose(markers),"circle",'Color','red','Size',3);

X1 = (0:8:8)/100;
Y1 = (0:8:8)/100;
Z1 = (0:-8:-8)/100;

markers2 = transpose(projectPoints(X1,Y1,Z1, 1));

zzz = [markers2(1,1), markers2(1,2); 
    markers2(2,1), markers2(2,2);
    markers2(4,1), markers2(4,2);
    markers2(3,1), markers2(3,2);
    markers2(7,1), markers2(7,2);
    markers2(8,1), markers2(8,2);
    markers2(6,1), markers2(6,2);
    markers2(5,1), markers2(5,2);
    markers2(1,1), markers2(1,2);
    markers2(3,1), markers2(3,2);
    ];
zzz2 = [markers2(7,1), markers2(7,2);
    markers2(5,1), markers2(5,2);
];
zzz3 = [
        markers2(2,1), markers2(2,2);
    markers2(6,1), markers2(6,2);];

zzz4 = [
        markers2(4,1), markers2(4,2);
    markers2(8,1), markers2(8,2);];
disp(zzz)
J2 = insertMarker(J2,markers2,"circle",'Color','red','Size',3);
J2 = insertShape(J2, 'Line', zzz,'LineWidth',2,'Color','red');
J2 = insertShape(J2, 'Line', zzz2,'LineWidth',2,'Color','red');

J2 = insertShape(J2, 'Line', zzz3,'LineWidth',2,'Color','red');
J2 = insertShape(J2, 'Line', zzz4,'LineWidth',2,'Color','red');
imshow(J2);

function tm = poseVectorToTransformationMatrix(i)
    x = readmatrix("data/poses.txt");
    w = x(i,1:3);

    theta = norm(w);
    k = w/norm(w);

    

    kx = [0.,-k(3), k(2); 
        k(3), 0., -k(1); 
        -k(2), k(1), 0.];


    R = eye(3) + sin(theta)*kx + (1-cos(theta))*kx*kx;

    t = x(i,4:6);
    tm = [R, transpose(t)];
end

function markers = projectPoints(X,Y,Z, i)
    k = readmatrix("data\K.txt");
    tm = poseVectorToTransformationMatrix(i);

    disp(tm);

    final = k*tm;
    markers = [];
    for ix=1:size(X,2)
        for ij=1:size(Y,2)
            for iz=1:size(Z,2)
                imagePoints = [final*[ X(1,ix); Y(1,ij); Z(1,iz); 1 ]];
                imagePoints = imagePoints/imagePoints(3);
                markers = [markers, imagePoints(1:2)];
            end
            
        end
    end
end