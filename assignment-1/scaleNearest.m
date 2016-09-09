function [output] = scaleNearest(input, factor)
    [~, ~, channels] = size(input);
    
    % make this generic per channels(like in case of RGBA). for now assumed to be RGB channels
    red_channel = input(:, :, 1);
    green_channel = input(:, :, 2);
    blue_channel = input(:, :, 3);
    
    red_scale = NearestNeighbor(red_channel, factor);
    green_scale = NearestNeighbor(green_channel, factor);
    blue_scale = NearestNeighbor(blue_channel, factor);
    
    output = cat(channels, red_scale, green_scale, blue_scale);
    
function [output] = NearestNeighbor(input, factor)
    oldsize = size(input);
    newsize = round(oldsize*factor);
    output = zeros(newsize(1), newsize(2), class(input));
    
    biggerSize = max(oldsize, newsize);
    scaleup = factor > 1;
    
    if not(scaleup)
        factor = 1/factor;
    end
    
    for y = 1:biggerSize(1)
        for x = 1:biggerSize(2)
            [xx, yy] = sampleNearest(x, y, factor);
            
            if scaleup
                output(y, x) = input(yy, xx);
            else
                output(yy, xx) = input(y, x);
            end
        end
    end
    
function [xx, yy] = sampleNearest(x, y, factor)
    xx = ceil(x/factor);
    yy = ceil(y/factor);