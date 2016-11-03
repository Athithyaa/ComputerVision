%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 4
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [result] = lcs(str1, str2)
    len1 = length(str1);
    len2 = length(str2);
    
    dp = zeros(len1+1, len2+1);
    dir = zeros(len1, len2);
    
    dp(1,:) = 0;
    dp(:, 1) = 0;
    
    for i = 2:len1+1
        for j = 2:len2+1
            if str1(i-1) == str2(j-1)
                dp(i,j) = dp(i-1, j-1) + 1;
                dir(i-1, j-1) = 1; % North west
            elseif dp(i-1, j) >= dp(i, j-1)
                dp(i, j) = dp(i-1, j);
                dir(i-1, j-1) = 2; % North
            else
                dp(i, j) = dp(i, j-1);
                dir(i-1, j-1) = 3; % west
            end
                
        end
    end
    
    index = dp(len1+1, len2+1);
    result = repmat('', 1, index);
    i = len1;
    j = len2;
    while (i ~= 0 && j ~= 0)
        if dir(i,j) == 1
            result(1, index) = str1(i);
            index = index-1;
            i = i-1;
            j = j-1;
        elseif dir(i, j) == 2
            i = i-1;
        else
            j = j-1;
        end
    end
end