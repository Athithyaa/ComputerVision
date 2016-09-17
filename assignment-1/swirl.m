%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 1
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out] = swirl(in)
    [rows, cols, ch] = size(in);
    out = zeros(rows, cols, ch, class(in));
    
    midx = rows/2;
    midy = cols/2;
    
    k = 100;
    
    for y = 1:rows
        for x = 1:cols
            % convert from (x, y) -> (r, theta) 
            % cartesian coordiantes to polar coordiantes
            [theta, rho] = cart2pol(x-midx, y-midy);
            
            % modify the theta and some delta
            phi = theta + (rho/k);
            
            % Convert the new polar coordinate values into 
            % cartesian coordinates
            [tx, ty] = pol2cart(phi, rho);
            
            tx = max(ceil(tx+midx), 1);
            ty = max(ceil(ty+midy), 1);
            
            if tx >=0 && tx < cols && ty >=0 && ty < rows
                out(y,x, :) = in(ty, tx, :);
            end

        end
    end