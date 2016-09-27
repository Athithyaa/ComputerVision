%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 2
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

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
pts1 = ginput2(4);

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
pts2 = ginput2(4);

H = computeHomography(pts1, pts2);
output = imageWarp(image1, image2, H);

figure;
imshow(output);