function disparityMap = computeDisparity(leftImage, rightImage, windowSize, algorithm)
    % left and right iamges are assumed to be gray scale or converted to
    % it.
    [rows, cols] = size(leftImage);
    % [rowsRight, colsRight] = size(rightImage);
    
    leftImage = im2double(leftImage);
    rightImage = im2double(rightImage);
    
    if (mod(windowSize, 2) == 0)
        error('window size must be odd')
    end
    
    weights = 1;
    if windowSize > 1
        % use gaussian weights
        weights  = fspecial('gaussian', [windowSize, windowSize]);
    end
    
    % disparity search range
    min = -6;
    max = 10;
    
    % create a disparity mpa
    disparityMap = zeros(rows, cols);
    
    hSize = floor(windowSize / 2); % size = 2*i + 1
    
    for r = (1+hSize : rows-hSize)
        for c = (1+hSize+abs(min) : cols-hSize-max)
            bestFit = 99999;
            offset = 0;
            
            % take the block from left image
            leftBlock = leftImage(r-hSize: r+hSize, c-hSize : c+hSize);
            
            for range = min : max
                % take the block from right image
                rightBlock = rightImage(r-hSize: r+hSize,...
                    c+range-hSize : c+range+hSize);
                
                if strcmp(algorithm, 'SSD')
                    % compute the SSD
                    diff = (leftBlock - rightBlock).^2;
                    conv = diff * weights;
                    fit = sum(conv(:));
                end
                
                if strcmp(algorithm, 'NCC')
                   % Compute the NCC
                   leftSq = leftBlock.^2;
                   rightSq = rightBlock.^2;
                   
                   fit = (sum(leftBlock.*rightBlock))/...
                       (sqrt(sum(leftSq(:))*sum(sum(rightSq))));
                end
                
                if fit < bestFit
                    bestFit = fit;
                    offset = range;
                end
            end
            
            disparityMap(r, c) = offset;
        end
    end
end