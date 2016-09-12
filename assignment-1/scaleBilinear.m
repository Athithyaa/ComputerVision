function [output] = scaleBilinear(input, factor)
    oldsize = [size(input, 1), size(input, 2)];
    newsize = round(oldsize*factor);
    output = zeros(newsize(1), newsize(2), size(input, 3), class(input));
    
    % make a copy of original image
    for i = 1:oldsize(1)
        for j = 1:oldsize(2)
            output(ceil(1+(i-1)*factor), ceil(1+(j-1)*factor), :) = input(i, j, :); 
        end
    end
    
    % now fill in the missing pixels by performing bilinear interpolation
    for i = 1:(oldsize(1)-2)*factor
        for j = 1:(oldsize(2)-2)*factor
             % value already copied from the original image
            if (rem(i-1, factor) == 0 && rem(j-1, factor)==0)
                continue;
            else
                % we need to calculate the value.
                %{
                
                 xo,yo          xo, y1
                   +------------+
                   |     .(x,y) |
                   |            |
                   +------------+
                  x1,yo         x1,y1
                
                %}
                %nearest four known pixels for the pixel being calculated.
                [x0, y0, x1, y1] = sampleBilinear(i, j, factor);
                f00 = output(x0, y0, :); 
                f10 = output(x1, y0, :);
                f01 = output(x0, y1, :);
                f11 = output(x1, y1, :);
           
                dx = rem(i-1,factor)/factor;
                dy = rem(j-1,factor)/factor;  
                
                a0 = f00;
                a1 = f10-f00;
                a2 = f01-f00;
                a3 = f00-f10-f01+f11;           
                output(i, j, :) = a0+a1*dx+a2*dy+a3*dx*dy;
            end
        end
    end
    
function [x0, y0, x1, y1] = sampleBilinear(i, j, factor)
    % calculate the top left and bottom right corner pixels
    % for bilinear interpolation
    x0 = ceil(i/factor)*factor-factor+1;
    y0 = ceil(j/factor)*factor-factor+1;
    x1 = ceil(i/factor)*factor-factor+1+factor;
    y1 = ceil(j/factor)*factor-factor+1+factor;