function [dmap] = stereoDP(left, right, maxDisp, occ)
    [rows, cols, ~] = size(left);
    dmap = zeros(rows, cols);

%     use index itself as direction
%     N = 1;
%     NW = 2;
%     W = 3;
  
    for row = 1:rows
        fprintf('top row = %d \n', row);
        Il = left(row,:);
        Ir = right(row, :);
        
        d = costMatrix(Il, Ir);
        D = zeros(rows+1, cols+1);
        Dir = zeros(rows+1, cols+1);
        
        D(1, 2:end) = (1:cols) * occ;
        D(2:end, 1) = (1:rows) * occ;
        D(2, 2) = d(1, 1);
               
        for i = 2:rows+1
            %fprintf('row = %d\n', i);
            for j = 2:cols+1
                % fprintf('i=%d j=%d [%d %d, %d %d, %d %d]\n', i, j, size(D), size(Dir), size(d));
                if i == 2 && j == 2
                    continue;
                end
                
                [D(i, j), Dir(i, j)] = min([D(i-1, j-1) + d(i-1, j-1), ...
                              D(i-1, j) + occ, ...
                              D(i, j-1) + occ]);
            end
        end

        % now use D to fill disparity map
        i = rows;
        j = cols;
        
        %fprintf('%d %d\n', i, j);
        pval = 0;
        nval = 0;
        wval = 0;
        col = cols;
        
        while(i ~= 1 && j ~= 1)
            % fprintf('i= %d j = %d\n', i, j);
            switch(Dir(i+1, j+1))
                case 1 % north west direction
                    % left pixel matches right pixel
                    % fprintf('match');
                    if nval ~= 0
                        dmap(row, col) = pval;
                        nval = 0;
                    elseif wval ~= 0
                        dmap(row, col) = pval;
                        wval = 0;
                    else
                        dmap(row, col) = pval;
                    end
                    col = col-1;
                    i = i-1;
                    j = j-1;
                    
                case 2 % north
                    % left pixel is unmatched
                    %fprintf('no left match');
                    if wval ~= 0
                        dmap(row, col) = pval;
                        wval = 0;
                        col = col-1;
                    end
                    nval = nval-1;
                    pval = pval-1;
                    % dmap(row, j) = pval;
                    i = i-1;
                case 3 % west
                    % right pixel is unmatched
                    %fprintf('no right match');
                    if nval ~= 0
                        dmap(row, col) = pval;
                        nval = 0;
                        col = col-1;
                    end
                    wval = wval+1;
                    pval = pval+1;
                    % dmap(row, j) = pval;
                    j = j-1;
            end
        end
    end
end

function [cost] = costMatrix(Il, Ir)
    n = size(Il, 2);
    cost = zeros(n, n);
    
    for i = 1:n
        cost(i, :) = (Ir-Il(i)).^2;
    end
end