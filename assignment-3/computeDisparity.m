function disparityMap = computeDisparity(leftImage, rightImage, wsize, algorithm)
    % left and right iamges are assumed to be gray scale or converted to
    % it.
    [rows, cols] = size(leftImage);
    
    % create a disparity mpa
    disparityMap = zeros(rows, cols);
    
    pad = (wsize - 1)/2;
    % pad left and right images and convert to double
    leftImage = im2double(padImage(leftImage, pad));
    rightImage = im2double(padImage(rightImage, pad));
    
    if (mod(wsize, 2) == 0)
        error('window size must be odd')
    end
    
    weights = 1;
    if wsize > 1
        % use gaussian weights
        weights  = fspecial('gaussian', [wsize, wsize]);
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