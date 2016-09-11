% This script creates a menu driven application

%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Sunil(suba5417@colorado.edu)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

% Display a menu and get a choice
choice = menu('Choose an option', 'Exit Program', 'Load Image', ...
    'Display Image', 'Mean Filter', 'Gaussian Filter', 'Scale Nearest', ...
    'Scale Bilinear', 'Fun Filter');  % as you develop functions, add buttons for them here
 
% Choice 1 is to exit the program
while choice ~= 1
   switch choice
       case 0
           disp('Error - please choose one of the options.')
           % Display a menu and get a choice
           choice = menu('Choose an option', 'Exit Program', 'Load Image', ...
    'Display Image', 'Mean Filter', 'Gaussian Filter', 'Scale Nearest', ...
    'Scale Bilinear', 'Fun Filter');   % as you develop functions, add buttons for them here

       case 2
           % Load an image
           image_choice = menu('Choose an image', 'lena1', 'mandril1', 'sully', 'yoda', 'shrek');
           switch image_choice
               case 1
                   filename = 'lena1.jpg';
                   
               case 2
                   filename = 'mandrill1.jpg';
                   
               case 3
                   filename = 'sully.bmp';
                   
               case 4
                   filename = 'yoda.bmp';
                   
               case 5
                   filename = 'shrek.bmp';
           end
           current_img = imread(filename);
           
       case 3
           % Display image
           figure
           imagesc(current_img);
           if size(current_img,3) == 1
               colormap gray
           end
           
       case 4
           % Mean Filter
           
           % 1. Ask the user for size of kernel
           k_size = str2double(inputdlg('Enter size of kernel', 'Enter value'));
           
           % 2. Call the appropriate function
           newImage = meanFilter(current_img, k_size);
           
           % 3. Display the old and the new image using subplot
           subplot(1, 2, 1);
           imagesc(current_img);
           
           subplot(1, 2, 2);
           imagesc(newImage);
           
           % 4. Save the newImage to a file
           imwrite(newImage, 'mean.jpg', 'jpg');
              
       case 5
           % Gaussian filter
           
           % 1. Ask the user for sd
           sigma = str2double(inputdlg('Enter the std. dev', 'Enter value'));;
           
           % 2. Call the appropriate function
           newImage = gaussianFilter(current_img, sigma);
           
           % 3. Display the old and the new image using subplot
           subplot(1, 2, 1);
           imagesc(current_img);
           
           subplot(1, 2, 2);
           imagesc(newImage);
           
           % 4. Save the newImage to a file
           imwrite(newImage, 'gauss.jpg', 'jpg');
           
       case 6
           % scale nearest
           
            % 1. Ask the user for scale factor
           factor = str2double(inputdlg('Enter scale factor', 'Enter value'));
           
           % 2. Call the appropriate function
           newImage = scaleNearest(current_img, factor);
           
           % 3. Display the old and the new image using subplot
           subplot(1, 2, 1);
           imagesc(current_img);
           
           subplot(1, 2, 2);
           imagesc(newImage);
           
           % 4. Save the newImage to a file
           imwrite(newImage, 'nearest.jpg', 'jpg');
           
       case 7
           % scale bilinear
           
           % 1. Ask the user for scale factor
           factor = str2double(inputdlg('Enter scale factor', 'Enter value'));
           
           % 2. Call the appropriate function
           newImage = scaleBilinear(current_img, factor);
           
           % 3. Display the old and the new image using subplot
           subplot(1, 2, 1);
           imagesc(current_img);
           
           subplot(1, 2, 2);
           imagesc(newImage);
           
           % 4. Save the newImage to a file
           imwrite(newImage, 'bilinear.jpg', 'jpg');
           
       case 8
           % fun filter
           funfilter = menu('choose fun filter', 'Fish eye', 'Image warp', ...
               'Sine', 'Swirl');
           switch funfilter
               case 1
                   output = fisheye(current_img);
               case 2
                   output = imageWarp(current_img);
               case 3
                   output = sine(current_img);
               case 4
                   output = swirl(current_img);
           end
           
           subplot(121);
           imagesc(current_img);
           subplot(122);
           imagesc(output);
           
           imwrite(output, 'funfilter.jpg', 'jpg');
   end
   % Display menu again and get user's choice
   choice = menu('Choose an option', 'Exit Program', 'Load Image', ...
    'Display Image', 'Mean Filter', 'Gaussian Filter', 'Scale Nearest', ...
    'Scale Bilinear', 'Fun Filter');   % as you develop functions, add buttons for them here
end
