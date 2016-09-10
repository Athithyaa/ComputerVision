function [output] = scaleNearest(input, factor)
    % output = nearest_neighbor_zoom(input, factor);
    
    [~, ~, channels] = size(input);
    
    % make this generic per channels(like in case of RGBA). for now assumed to be RGB channels
    red_channel = input(:, :, 1);
    green_channel = input(:, :, 2);
    blue_channel = input(:, :, 3);
    
    red_scale = NearestNeighborInterpolate(red_channel, factor);
    green_scale = NearestNeighborInterpolate(green_channel, factor);
    blue_scale = NearestNeighborInterpolate(blue_channel, factor);
    
    output = cat(channels, red_scale, green_scale, blue_scale);
    
    
function [output] = NearestNeighborInterpolate(input, factor)
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
            [xx, yy] = sampleNearest(x/factor, y/factor);
           
            if scaleup
                output(y, x) = input(yy, xx);
            else
                output(yy, xx) = input(y, x);
            end
        end
    end
    
    % I might want to do smoothing after scale up or scale down.
    
function [xx, yy] = sampleNearest(x, y)
    xx = max(round(x), 1);
    yy = max(round(y), 1);