%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 1
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output] = scaleBilinear(input, factor)
    oldsize = [size(input, 1), size(input, 2)];
    newsize = floor(oldsize*factor);
    output = zeros(newsize(1), newsize(2), size(input, 3), class(input));
    
    for i = 1:size(output, 1)
        for j = 1:size(output, 2)   
            % calculate offset along x and y axis
            xd = rem(i/factor, 1);
            yd = rem(j/factor, 1);
            
            [x0, y0, x1, y1] = sampleBilinear(i, j, factor, oldsize);
            
            ctl = input(x0,y0,:);
            cbl = input(x1,y0,:);
            ctr = input(x0,y1,:);
            cbr = input(x1,y1,:);
            
            tr = (ctr*yd)+(ctl*(1-yd));
            br = (cbr*yd)+(cbl*(1-yd));
            output(i,j,:) = (br*xd)+(tr*(1-xd));
        end
    end
    
function [x0, y0, x1, y1] = sampleBilinear(i, j, factor, oldsize)
    r = floor(i/factor);
    c = floor(j/factor);
    
    x0 = max(floor(r), 1);
    y0 = max(floor(c), 1);
    x1 = min(floor(r+1), oldsize(1));
    y1 = min(floor(c+1), oldsize(2));
            