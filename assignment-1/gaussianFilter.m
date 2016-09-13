function [outImg] = gaussianFilter(inImg, sigma)
    % extract rgb and run mean filter all three. 
    % then cat all 3 channels togather. otherwise figure out 
    % how to perform 3D mean filter by addressing padding in 3D.
    [~, ~, channels] = size(inImg);
    
    % make this generic. for now assumed to be RGB channels
    red_channel = inImg(:, :, 1);
    green_channel = inImg(:, :, 2);
    blue_channel = inImg(:, :, 3);
    
    %gaussKernel = fspecial('gaussian', [3 3], sigma);
    k = ceil(2*sigma)+1;
    h = floor(k/2);
    [x, y] = meshgrid(-h:h, -h:h);
    temp = (1/(2*pi*sigma^2))*exp(-(x.^2 + y.^2) / (2*sigma.^2));
    gaussKernel = temp / sum(sum(temp));
    
    red_filter = applyFilter(red_channel, gaussKernel);
    green_filter = applyFilter(green_channel, gaussKernel);
    blue_filter = applyFilter(blue_channel, gaussKernel);
    
    outImg = cat(channels, red_filter, green_filter, blue_filter);