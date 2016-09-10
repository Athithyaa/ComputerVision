function [output] = scaleNearest(input, factor)
    oldsize = [size(input, 1), size(input, 2)];
    newsize = round(oldsize*factor);
    output = zeros(newsize(1), newsize(2), size(input, 3), class(input));
    
    biggerSize = max(oldsize, newsize);
    scaleup = factor > 1;
    
    if not(scaleup)
        factor = 1/factor;
    end
    
    for y = 1:biggerSize(1)
        for x = 1:biggerSize(2)
            [xx, yy] = sampleNearest(x/factor, y/factor);
           
            if scaleup
                output(y, x, :) = input(yy, xx, :);
            else
                output(yy, xx, :) = input(y, x, :);
            end
        end
    end
    
    % I might want to do smoothing after scale up or scale down.
    
function [xx, yy] = sampleNearest(x, y)
    xx = max(round(x), 1);
    yy = max(round(y), 1);