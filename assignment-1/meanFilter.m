%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 1
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fimg = meanFilter(img , k_size)
    % extract rgb and run mean filter on all three. 
    % then cat all 3 channels togather. otherwise figure out 
    % how to perform 3D mean filter by addressing padding in 3D.
    [~, ~, channels] = size(img);
    
    % make this generic per channels(like in case of RGBA). for now assumed to be RGB channels
    red_channel = img(:, :, 1);
    green_channel = img(:, :, 2);
    blue_channel = img(:, :, 3);
    
    meanKernel = 1/(k_size^2) * ones(k_size, k_size);
    red_filter = applyFilter(red_channel, meanKernel);
    green_filter = applyFilter(green_channel, meanKernel);
    blue_filter = applyFilter(blue_channel, meanKernel);
    
    % now concat all the channels
    fimg = cat(channels, red_filter, green_filter, blue_filter);