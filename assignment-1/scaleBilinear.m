function [outImg] = scaleBilinear(inImg, factor)
     [~, ~, channels] = size(inImg);
    
    % make this generic per channels(like in case of RGBA). for now assumed to be RGB channels
    red_channel = inImg(:, :, 1);
    green_channel = inImg(:, :, 2);
    blue_channel = inImg(:, :, 3);
    
    red_scale = BilinearInterpolate(red_channel, factor);
    green_scale = BilinearInterpolate(green_channel, factor);
    blue_scale = BilinearInterpolate(blue_channel, factor);
    
    outImg = cat(channels, red_scale, green_scale, blue_scale);

function [output] = BilinearInterpolate(input, factor)
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
            [xx, yy] = sampleBilinear(x, y, factor);
            
            if scaleup
                output(y, x) = input(yy, xx);
            else
                output(yy, xx) = input(y, x);
            end
        end
    end
    
function [value] = sampleBilinear(x, y)