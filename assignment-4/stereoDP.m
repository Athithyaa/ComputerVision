%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 4
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dmap] = stereoDP(left, right, maxDisp, occ)
    [rows, cols, ~] = size(left);
    dmap = zeros(rows, cols);
    
    left = im2double(left);
    right = im2double(right);
    
%     use index itself as direction
%     N = 1;
%     NW = 2;
%     W = 3;
  
    for row = 1:rows
        fprintf('row = %d \n', row);
        Il = left(row,:);
        Ir = right(row, :);
        
        d = costMatrix(Il, Ir);
        D = zeros(cols+1, cols+1);
        Dir = zeros(cols+1, cols+1);
        
        D(1, 2:end) = (1:cols) * occ;
        D(2:end, 1) = (1:cols) * occ;
        D(2, 2) = d(1, 1);
               
        for i = 2:cols+1
            %fprintf('row = %d\n', i);
            for j = 2:cols+1
                % fprintf('i=%d j=%d [%d %d, %d %d, %d %d]\n', i, j, size(D), size(Dir), size(d));
                if i == 2 && j == 2
                    continue;
                end
                
                [D(i, j), Dir(i, j)] = min([D(i-1, j-1)+d(i-1, j-1), ...
                              D(i-1, j) + occ, ...
                              D(i, j-1) + occ]);
            end
        end

        % now use D to fill disparity map
        i = cols;
        j = cols;
        
        %fprintf('%d %d\n', i, j);
        while(i ~= 1 && j ~= 1)
            % fprintf('i= %d j = %d\n', i, j);
            switch(Dir(i+1, j+1))
                case 1 % north west direction
                    % left pixel matches right pixel
                    dmap(row, j) = abs(i-j);
                    i = i-1;
                    j = j-1;
                case 2 % north
                    % left pixel is unmatched
                    dmap(row, j) = NaN;
                    i = i-1;
                case 3 % west
                    % right pixel is unmatched                    
                    j = j-1;
            end
        end
    end
end

function [cost] = costMatrix(Il, Ir)
    n = size(Il, 2);
    cost = zeros(n, n);
    
    for i = 1:n
        cost(i, :) = (Il - Ir(i)).^2;
    end
end