function [dmap] = computeDisparity2(leftIm, rightIm)
    % compute the disparity of two images (left and right)
    % assumed to be grayscale and rectified.
     [rows, cols] = size(leftIm);
     windowSize = 1;
     
     % disparity range
     drange = 16;
     dmap = zeros(rows, cols, 1);
     
     for r = 1:rows
         minrow = max(1, r-windowSize);
         maxrow = min(rows, r+windowSize);
         
         for c = 1:cols
             mincol = max(1, c-windowSize);
             maxcol = min(cols, c+windowSize);
             
             dmin = max(-drange, 1 - mincol);
             dmax = min(drange, cols - maxcol);
             
             refMatch = leftIm(minrow:maxrow, mincol:maxcol);
             
             bestSsd = intmax('int16');
             bestOffset = intmax('int16');
             
             for d = dmin : dmax
                 match = rightIm(minrow:maxrow, (mincol+d):(maxcol+d));
                 ssd = sum(sum((match - refMatch).^2));
                 if ssd < bestSsd
                     bestSsd = ssd;
                     bestOffset = d;
                 end
             end
             
             dmap(r, c) = bestOffset;
             
         end
     end
    
end