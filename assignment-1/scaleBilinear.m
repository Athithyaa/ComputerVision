function [output] = scaleBilinear(input, factor)
    oldsize = [size(input, 1), size(input, 2)];
    newsize = round(oldsize*factor);
    output = zeros(newsize(1), newsize(2), size(input, 3), class(input));
    
    % make a copy of original image
    for i = 1:oldsize(1)
        for j = 1:oldsize(2)
            output(1+(i-1)*factor, 1+(j-1)*factor, :) = input(i, j, :); 
        end
    end
    
    % now fill in the missing pixels by performing bilinear interpolation
    
    
function [xx, yy] = sampleBilinear(x, y)