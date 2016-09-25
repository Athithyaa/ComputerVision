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
   exit;
else
   image1 = imread(imageFile1);
 end

 % read second image
 [imageFile2, pathname] = ...
     uigetfile({'*.jpg';'*.png';'*.bmp'},'Choose image 2');
 if isequal(imageFile2,0)
   exit;
else
   image2 = imread(imageFile1);
 end

 imagesc(image1);
 [x, y] = ginput(4);
 
 image
 