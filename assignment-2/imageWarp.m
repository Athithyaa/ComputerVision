%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 2
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = imageWarp(image1, image2, H)
    [r1, c1, ~] = size(image1);
    [r2, c2, ~] = size(image2);
    c  = H * [ 1 1  r1 r1 ;
               1 c1 1  c1 ;
               1 1  1  1 ];
    ymin = min((c(1,:)./c(3,:)));
    xmin = min((c(2,:)./c(3,:)));
    ymax = max((c(1,:)./c(3,:)));
    xmax = max((c(2,:)./c(3,:)));
    
    Sr = round(abs(min([ymin 1])));
    Sc = round(abs(min([xmin 1])));
    Srmax = round(max([ymax r2]));
    Scmax = round(max([xmax c2]));
    
    im1 = im2double(image1);
    im2 = im2double(image2);
    
    [cm, rm] = meshgrid(1-Sc:Scmax,1-Sr:Srmax);
    [r, c] = size(rm);    

    K = H \ [rm(:)'; cm(:)'; ones(1,r*c)];
    ro = reshape(K(1,:)./K(3,:),r,c);
    co = reshape(K(2,:)./K(3,:),r,c);

    [rm, cm] = meshgrid(1:c1,1:r1);

    output(:,:,1) = interp2(rm, cm, im1(:,:,1), co, ro, 'linear');
    output(:,:,2) = interp2(rm, cm, im1(:,:,2), co, ro, 'linear');
    output(:,:,3) = interp2(rm, cm, im1(:,:,3), co, ro, 'linear');

    output(Sr+1:Sr+r2, Sc+1:Sc+c2, :) = im2(1:r2, 1:c2, :);