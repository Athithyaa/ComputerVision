%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 3
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function disparityMap = computeDisparity(leftImage, rightImage, wsize, algorithm)
    % left and right iamges are assumed to be gray scale or converted to
    % it.
    [rows, cols] = size(leftImage);
    
    % create a disparity mpa
    disparityMap = zeros(rows, cols);
    
    % pad left and right images and convert to double
    pad = (wsize - 1)/2;
    leftImage = im2double(padImage(leftImage, pad));
    rightImage = im2double(padImage(rightImage, pad));
    
    weights = 1;
    if wsize > 1
        % use gaussian weights
        weights = gaussianKerenel(wsize);
    end
    
    % disparity search range
    min = 0;
    max = 64;
    
    [~, scol, ~] = size(rightImage);
    
    for r = 1:rows
        for c = 1:cols
            
            bestFit = -99999;
            if strcmp(algorithm, 'SSD')
                bestFit = 99999;
            end
            
            offset = 0;
            leftBlock = leftImage(r:r+2*pad, c:c+2*pad);
            
            for range = min:max
                if (c+range < 1 || c+range+2*pad > scol)
                    continue;
                end
                rightBlock = rightImage(r:r+2*pad, ...
                    c+range:c+2*pad+range);
                
                if strcmp(algorithm, 'SSD')
                    % compute the SSD
                    leftFitler = leftBlock .* weights;
                    rightFilter = rightBlock .* weights;
                    diff = (leftFitler - rightFilter).^2;
                    fit = sum(diff(:));
                    
                    if fit < bestFit
                        bestFit = fit;
                        offset = range;
                    end
                end
                
                if strcmp(algorithm, 'NCC')
                   % Compute the NCC
                   meanLeft = mean(leftBlock(:));
                   meanRight = mean(rightBlock(:));
                   N = size(meanLeft, 1) * size(meanRight, 2);
                   
                   temp = (leftBlock - meanLeft).*(rightBlock - meanRight); 
                   varleft = ((leftBlock -meanLeft).^2); 
                   varright =((rightBlock -meanRight).^2); 

                    fit = sum(temp(:))/(N*sqrt(sum(varleft(:) * sum(varright(:)))));
                    if fit > bestFit 
                        bestFit = fit;
                        offset = range;
                    end
                end
                
            end
            
            disparityMap(r, c) = offset;
        end
    end
end

function [image] = padImage(image, pad)
    [rows, cols, ~] = size(image);
    
    % pad the image
    image(rows+2*pad, cols+2*pad) = 0;
    image = circshift(image, [pad pad]);
end

function [gKerenel] = gaussianKerenel(k)
    h = floor(k/2);
    sigma = .5;
    
    % create meshgrid
    range = -h:h;
    rsize = length(range);
    x = zeros(rsize, rsize);
    y = zeros(rsize, rsize);
    for i = 1 : length(x)
    	x(:, i) = range(i);
        y(:, i) = range;
    end

    temp = (1/(2*pi*sigma^2))*exp(-(x.^2 + y.^2) / (2*sigma.^2));
    gKerenel = temp / sum(sum(temp));
end