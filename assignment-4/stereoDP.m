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
        
        d = costMatrixSD(Il, Ir);
        %d = costMatrixSSD(left, right, 5, row);
        %d = costMatrixNCC(left, right, 3, row);
        
        D = zeros(cols+1, cols+1);
        Dir = zeros(cols+1, cols+1);
        
        D(1, 2:end) = (1:cols) * occ;
        D(2:end, 1) = (1:cols) * occ;
        D(2, 2) = d(1, 1);
               
        for i = 2:cols+1
            % fprintf('row = %d\n', i);
            for j = 2:cols+1
                % fprintf('i=%d j=%d [%d %d, %d %d, %d %d]\n', i, j, size(D), size(Dir), size(d));
                if i == 2 && j == 2
                    continue;
                end
                [D(i, j), Dir(i, j)] = mina(D(i-1, j-1) + d(i-1, j-1), ...
                              D(i-1, j) + occ, ...
                              D(i, j-1) + occ);
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
                    dmap(row, i) = abs(i-j);
                    i = i-1;
                    j = j-1;
                case 2 % north
                    % left pixel is unmatched
                    dmap(row, i) = nan;
                    i = i-1;
                case 3 % west
                    % right pixel is unmatched                    
                    j = j-1;
            end
        end
    end
end

function [val, ind] = mina(a, b, c)
    if a < b && a < c
        val = a;
        ind = 1;
        return;
    end
    
    if b < c && b < a
        val = b;
        ind = 2;
        return;
    end
    
    val = c;
    ind = 3;
end


function [cost] = costMatrixSD(Il, Ir)
    n = size(Il, 2);
    cost = zeros(n, n);
    
    % compute squared difference
     for i = 1:n
         cost(i, :) = (Ir - Il(i)).^2;
         % cost(i, :) = (Il - Ir(i)).^2;
     end 
end

function [cost] = costMatrixSSD(left, right, wsize, row)
    n = size(left, 2);
    cost = zeros(n, n);

    % pad the image and compute SSD or NCC
    pad = (wsize - 1)/2;
    left = im2double(padImage(left, pad));
    right = im2double(padImage(right, pad));
    
    weights = 1;
    if wsize > 1
        % use gaussian weights
        weights = gaussianKerenel(wsize);
    end
    
    Il = left(row:row+2*pad, :);
    Ir = right(row:row+2*pad, :);
    
    for i = 1:n
        lref = Il(:, i:i+2*pad);
        for j = 1:n
            rref = Ir(:, j:j+2*pad);
            
            lf = lref .* weights;
            rf = rref .* weights;
            diff = (rf - lf).^2;
            ssd = sum(diff(:));
            
            cost(i, j) = ssd;
        end
    end
end

function [cost] = costMatrixNCC(left, right, wsize, row)
    n = size(left, 2);
    cost = zeros(n, n);

    % pad the image and compute SSD or NCC
    pad = (wsize - 1)/2;
    left = im2double(padImage(left, pad));
    right = im2double(padImage(right, pad));
    
    Il = left(row+pad-1:row+pad+1, :);
    Ir = right(row+pad-1:row+pad+1, :);
    
    for i = 1:n
        lref = Il(:, i+pad-1:i+pad+1);
        for j = 1:n
            rref = Ir(:, j+pad-1:j+pad+1);
            
            meanLeft = mean(lref(:));
            meanRight = mean(rref(:));
            N = size(meanLeft, 1) * size(meanRight, 2);
            
            temp = (lref - meanLeft).*(rref - meanRight); 
            varleft = ((lref - meanLeft).^2); 
            varright =((rref - meanRight).^2); 
            ncc = sum(temp(:))/(N*sqrt(sum(varleft(:) * sum(varright(:)))));
            
            cost(i, j) = ncc;
        end
    end
end

function [image] = padImage(image, pad)
    [rows, cols, ~] = size(image);
    
    % pad the image
    image(rows+2*pad, cols+2*pad) = 0;
    image = circshift(image, [pad pad]);
end

function [gKerenel] = gaussianKerenel(k)
    h = floor(k/2);
    sigma = .5;
    
    % create meshgrid
    range = -h:h;
    rsize = length(range);
    x = zeros(rsize, rsize);
    y = zeros(rsize, rsize);
    for i = 1 : length(x)
    	x(:, i) = range(i);
        y(:, i) = range;
    end

    temp = (1/(2*pi*sigma^2))*exp(-(x.^2 + y.^2) / (2*sigma.^2));
    gKerenel = temp / sum(sum(temp));
end