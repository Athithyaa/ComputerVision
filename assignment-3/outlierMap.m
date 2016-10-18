%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 3
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outlier] = outlierMap(lr, rl, th)
    [rows, cols] = size(lr);
    
    outlier = zeros(rows, cols);
    
    for r = 1:rows
        for c = 1:cols
            temp = lr(r, c);
            
            if (c-temp < 1 || c-temp > cols)
                continue;
            end
            
            if abs(temp - rl(r, c-temp)) > th
                outlier(r, c) = 1;
            end
        end
    end
end