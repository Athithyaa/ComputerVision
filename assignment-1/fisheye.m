%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 1
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out] = fisheye(in)
      out = zeros(size(in, 1), size(in, 2), size(in, 3), class(in));
    
    midy = size(in, 1)/2;
    midx = size(in, 2)/2;
    
    for y = 1:size(out,1)
        for x = 1:size(out, 2)
            xx = (x - midx)/midx;
            yy = (y - midy)/midy;
            
%             FG-Squicircular mapping
%             u = xx*sqrt(1-(yy^2/2));
%             v = yy*sqrt(1-(xx^2/2));
%             
%             u = floor((u * midx) + midx);
%             v = floor((v * midy) + midy);
%             
            % elliptical grid mapping
            temp = sqrt(xx^2+yy^2-xx^2*yy^2)/sqrt(xx^2+yy^2);
            u = xx*temp;
            v = yy*temp;
            u = floor((u * midx) + midx);
            v = floor((v * midy) + midy);
            
            % check for bounds
            %fprintf('%f %f\n', u, v);
            if u >=1 && v >= 1 && u <= size(out, 1) && u <= size(out, 2)
                out(v, u, :) = in(y, x,:);
            end
            
        end
    end