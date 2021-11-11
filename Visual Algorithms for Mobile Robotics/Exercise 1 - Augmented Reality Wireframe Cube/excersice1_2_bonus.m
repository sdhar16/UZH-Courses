clear;
clearvars;

imagefiles = dir('data/images/*.jpg');      
nfiles = length(imagefiles);    % Number of files found

%nfiles= 1;
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentimage = imread(fullfile("data/images/",currentfilename));
   images{ii} = currentimage;
end

for ii=1:nfiles
    image = images{ii};
    image1 = rgb2gray(image);



    X = (0:4:32)/100;
    Y = (0:4:20)/100;
    Z = zeros(1);
    
    [umarkers, markers] = projectPoints(X,Y,Z,ii);
    
    markers = transpose(markers);
    umarkers = transpose(umarkers);
    
    J2 = insertMarker(image,markers(:,1:2),"circle",'Color','red','Size',3);
        
    
    uimage = uint8(undistort_image(image1));
    
    
    
    J3 = insertMarker(uimage,umarkers(:,1:2),"circle",'Color','red','Size',3);
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    X1 = (0:8:8)/100;
    Y1 = (0:8:8)/100;
    Z1 = (0:-8:-8)/100;
    
    
    [umarkers2, markers2] = projectPoints(X1,Y1,Z1, ii);
    
    markers2 = transpose(umarkers2);
    
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
    J2 = J3;
    J2 = insertMarker(J2,markers2,"circle",'Color','red','Size',3);
    J2 = insertShape(J2, 'Line', zzz,'LineWidth',2,'Color','red');
    J2 = insertShape(J2, 'Line', zzz2,'LineWidth',2,'Color','red');
    
    J2 = insertShape(J2, 'Line', zzz3,'LineWidth',2,'Color','red');
    J2 = insertShape(J2, 'Line', zzz4,'LineWidth',2,'Color','red');
    imshow(J2);

    imwrite(J2,[sprintf('data/outputs_bilinear/%03d',ii) '.jpg']);
end
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

function [umarkers, markers] = projectPoints(X,Y,Z, i)
    k = readmatrix("data\K.txt");

    k1 = -1.6774e-06;
    k2 = 2.5847e-12;

    u0 = k(1,3);
    v0 = k(2,3);

    tm = poseVectorToTransformationMatrix(i);
       
    markers = [];
    umarkers = [];
    for ix=1:size(X,2)
        for ij=1:size(Y,2)
            for iz=1:size(Z,2)
                imagePoints = [k*tm*[ X(1,ix); Y(1,ij); Z(1,iz); 1 ]];
                imagePoints = imagePoints/imagePoints(3);

                u = imagePoints(1);
                v = imagePoints(2);

                r2 = (u-u0)^2 + (v-v0)^2;

                point = (1+k1*r2+k2*r2^2)*[u-u0; v-v0] + [u0; v0];
                umarkers = [umarkers, [u;  v]];
                markers = [markers, point];
            end
            
        end
    end
end

function output = undistort_image(image)
    k = readmatrix("data\K.txt");
    k1 = -1.6774e-06;
    k2 = 2.5847e-12;

    v0 = k(1,3);
    u0 = k(2,3);

    output = zeros(size(image));

    for ix=1:size(output,1)
        for ij=1:size(output,2)
            u = ix;
            v = ij;

            r2 = (u-u0)^2 + (v-v0)^2;

            point = (1+k1*r2+k2*r2^2)*[u-u0; v-v0] + [u0; v0];

            posX = point(1,1);
            posY = point(2,1);

            intensity = bilinear_inter(image, posX, posY);

            output(u,v) = intensity;
        end
    end
end

function pxf = bilinear_inter(imArr, posX, posY)
    modXi = floor(posX);
	modYi = floor(posY);
	modXf = posX - modXi;
	modYf = posY - modYi;
    
    tl = imArr(modXi, modYi);
	bl = imArr(modXi, modYi+1);
	tr = imArr(modXi +1 , modYi);
	br = imArr(modXi + 1, modYi + 1);

	b = modXf * br + (1. - modXf) * bl;
	t = modXf * tr + (1. - modXf) * tl;
	pxf = modYf * b + (1. - modYf) * t;
end