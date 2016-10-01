%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 2
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

choice = menu('Choose an option', 'Exit Program', 'Image mosaic', ...
    'RANSAC', 'Frame Image'); 

if choice == 1
    return;
end

% select image-1 that needs to be warped into image-2 plane of
% reference
[imageFile1, pathname] = ...
    uigetfile({'*.jpg';'*.png';'*.bmp'},'Choose image 1 to be warped');
if isequal(imageFile1,0)
  return;
else
  image1 = imread(imageFile1);
end

figure;
imagesc(image1);
if choice ~= 3
    pts1 = ginput2(4);
end

% select image-2 that serves as reference image.
[imageFile2, pathname] = ...
    uigetfile({'*.jpg';'*.png';'*.bmp'},'Choose image 2(reference)');
if isequal(imageFile2,0)
  return;
else
  image2 = imread(imageFile2);
end
 
figure;
imagesc(image2);
if choice ~= 3
    pts2 = ginput2(4);
end
switch choice
    case 2 % Image Mosaic
        H = computeHomography(pts1, pts2);
        output = imageWarp(image1, image2, H, 'MOSAIC');
        imwrite(output, 'mosaic.jpg');
        
    case 3 % RANSAC
        [fit, H] = ransac(image1, image2);
        output = imageWarp(image1, image2, H, 'MOSAIC');
        imwrite(output, 'ransac.jpg');
        
    case 4 % Frame image to billboard
        H = computeHomography(pts1, pts2);
        output = imageWarp(image1, image2, H, 'FRAME');
        imwrite(output, 'frame.jpg');
end

figure;
imshow(output);