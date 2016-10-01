%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 2
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = imageWarp(image1, image2, H, method)
    [row1, col1, ~] = size(image1);
    
    % transform the image-1 co-ordinates to the image-2 coordinate system.
    % using the homography matrix H (computed as x2 = H*x1)
    tcoord = H * [1        1       1;
                  1        col1    1;
                  row1     col1    1;
                  row1     1       1]';
    
    % convert to inhomogenous coordinates
    for i = 1:3
        tcoord(i,:) = tcoord(i,:)./tcoord(3,:);
    end
    
    % calculate the box for image 1
    box1.rowmin = min(tcoord(1, :)); box1.colmin = min(tcoord(2, :));
    box1.rowmax = max(tcoord(1, :)); box1.colmax = max(tcoord(2, :));
    
    % Box the dimensions for image 2
    [row2, col2, ~] = size(image2);
    box2.rowmin = 1;    box2.colmin = 1;
    box2.rowmax = row2; box2.colmax = col2;
    
    % get the bounding box for the image1 and image2
    bbox = getBoundingBox(box1, box2); 
    
    % if the method is frame image(billboard) then follow direct and manual method.
    % since interp2 and meshgrid overwrites cropped image in dest.
    % I can also apply this method for mosaic but it's slower.
    if strcmp(method, 'FRAME')
        bbox.rowmin = abs(bbox.rowmin);
        bbox.colmin = abs(bbox.colmin);
        % Without using meshgrid and interp2.
        rowoff = 0;
        coloff = 0;
        if bbox.rowmin < 0
            rowoff = -bbox.rowmin + 1;
        end
        if bbox.colmin < 0
            coloff = -bbox.colmin + 1;
        end
    
        output = zeros(bbox.rowmax + (rowoff), bbox.colmax + (coloff), 3, class(image1));
    
        output(box2.rowmin+rowoff:box2.rowmin+rowoff+row2-1, box2.colmin+coloff:box2.colmin+coloff+col2-1, :) = image2(1:row2, 1:col2, :);
   
        for r = ceil(box1.rowmin) : ceil(box1.rowmax)
            for c = ceil(box1.colmin) : ceil(box1.colmax)
                hcoord = H \ [r c 1]';
                hcoord = hcoord / hcoord(3);
            
                xr = hcoord(1);
                yc = hcoord(2);
            
                if xr > 1 && yc > 1 && xr < row1 && yc < col1
                    %fprintf('%d %d %d %d\n', xr, yc, r, c);
                    output(r+rowoff, c+coloff, : ) = sampleBilinear(xr, yc, image1);
                end            
            end
        end
        return;
    end
    % Else perform Image mosaic using interp2 and meshgrid is faster
    [colmat, rowmat] = meshgrid(1-bbox.colmin:bbox.colmax, 1-bbox.rowmin:bbox.rowmax);
    [rows, cols] = size(rowmat);    

    % calculate the coordinates in image1 using backward mapping.
    % (x, y) = inv(H) * (x', y')
    mcoord = H \ [rowmat(:)'; colmat(:)'; ones(1, rows*cols)];
    ro = reshape(mcoord(1,:)./mcoord(3,:), rows, cols);
    co = reshape(mcoord(2,:)./mcoord(3,:), rows, cols);

    [rowmat, colmat] = meshgrid(1:col1, 1:row1);
    
    clear output;
    output = zeros(rows, cols);
    
    image1 = im2double(image1);
    image2 = im2double(image2);
    
    % perform a bilinear interpolation 
    for i = 1:3
        output(:, :, i) = ...
            interp2(rowmat, colmat, image1(:, :, i), co, ro, 'linear');
    end
    
    output(bbox.rowmin+1:bbox.rowmin+row2, ...
        bbox.colmin+1:bbox.colmin+col2, :) = image2(1:row2, 1:col2, :);
end

function bbox = getBoundingBox(box1, box2)
    bbox.rowmin = round(abs(min([box1.rowmin box2.rowmin])));
    bbox.colmin = round(abs(min([box1.colmin box2.colmin])));
    bbox.rowmax = round(max([box1.rowmax box2.rowmax]));
    bbox.colmax = round(max([box1.colmax box2.colmax]));
end

function val = sampleBilinear(r, c, image)    
    x0 = max(floor(r), 1);
    y0 = max(floor(c), 1);
    
    x1 = min(floor(r+1), size(image, 1));
    y1 = min(floor(c+1), size(image, 2));
    
    f00 = image(x0,y0,:);
    f10 = image(x1,y0,:);
    f01 = image(x0,y1,:);
    f11 = image(x1,y1,:);
    
    xd = rem(r, 1);
    yd = rem(c, 1);
            
    tr = (f01*yd)+(f00*(1-yd));
    br = (f11*yd)+(f10*(1-yd));
    val = (br*xd)+(tr*(1-xd));
end