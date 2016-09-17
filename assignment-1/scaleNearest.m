%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 1
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output] = scaleNearest(input, factor)
    oldsize = [size(input, 1), size(input, 2)];
    newsize = floor(oldsize*factor);
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
    
function [xx, yy] = sampleNearest(x, y)
    xx = max(floor(x), 1);
    yy = max(floor(y), 1);