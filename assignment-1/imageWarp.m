%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 1
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out] = imageWarp(in)
     [rows, cols, ch] = size(in);
     out = zeros(rows, cols, ch, class(in));
     
     midx = rows/2;
     midy = cols/2;
     
      for y = 1:rows
        for x = 1:cols
            dx = x - midx;
            dy = y - midy;
            
            tx = x; % warp along y axis
            %tx = max(ceil(sign(dx)*(dx)^2/midx + midx), 1);
            
            
            %ty = y; % warp along x axis
            ty = max(ceil(sign(dy)*(dy)^2/midy + midy), 1);
            
            if tx >=0 && tx < cols && ty >=0 && ty < rows
                out(y,x, :) = in(ty, tx, :);
            end
        end
      end