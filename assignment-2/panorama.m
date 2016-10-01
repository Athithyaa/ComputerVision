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

% read first image
[imageFile1, pathname] = ...
    uigetfile({'*.jpg';'*.png';'*.bmp'},'Choose image 1');
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

% read second image
[imageFile2, pathname] = ...
    uigetfile({'*.jpg';'*.png';'*.bmp'},'Choose image 2');
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
        
    case 3 % RANSAC
        H = ransac(image1, image2);
        output = imageWarp(image1, image2, H, 'MOSAIC');
        
    case 4 % Frame image to billboard
        H = computeHomography(pts1, pts2);
        output = imageWarp(image1, image2, H, 'FRAME');
end

figure;
imshow(output);