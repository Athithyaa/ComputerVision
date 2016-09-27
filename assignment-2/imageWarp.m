function output = imageWarp(image1, image2, H)
    im1 = image1;
    im2 = image2;
    T = maketform('projective', H);
    [im2t,xdataim2t,ydataim2t]=imtransform(im1,T);
    % now xdataim2t and ydataim2t store the bounds of the transformed im2
    xdataout=[min(1,xdataim2t(1)) max(size(im2,2),xdataim2t(2))];
    ydataout=[min(1,ydataim2t(1)) max(size(im2,1),ydataim2t(2))];
    % let's transform both images with the computed xdata and ydata
    im2t=imtransform(im1,T,'XData',xdataout,'YData',ydataout);
    im1t=imtransform(im2,maketform('affine',eye(3)),'XData',xdataout,'YData',ydataout);
    ims=im1t/2+im2t/2;
    figure, imshow(ims)
    output = ims;
        %{
    bbox = getBoundingBox(image1, H);
    Imw = warp(double(image1), H, bbox);
    Imw(isnan(Imw)) = 0;
    ImWarpMax = Imw;
    ImWarpMax = max(ImWarpMax, Imw)/255;
    output = ImWarpMax;
    
    % warp image 1 to mosaic image
    nImages = 2;
    images = {image1, image2};
    ImWarpMax = [];
    for i=1:nImages
        Imw = warp(double(images{i}), H, bbox);
        Imw(isnan(Imw)) = 0;
        if isempty(ImWarpMax)
            ImWarpMax = Imw;
        end
        ImWarpMax = max(ImWarpMax, Imw);
    end
    ImWarpMax = ImWarpMax / 255;
    figure, imagesc(ImWarpMax);
    
    [r1, c1, ~] = size(image1);
    [r2, c2, ~] = size(image2);
    
    p1 = [1 1 1] * H;
    t.start = p1/p1(3);
    
    p2 = [r1 c1 1] * H;
    t.end = p2/p2(3);
    
    clear output;
    outsize.start = ceil(min(t.start, [1 1 1]));
    outsize.end = ceil(max(t.end, [r2, c2, 1]));
    
    rows = outsize.end(:, 1);
    cols = outsize.end(:, 2);
    output = zeros(rows, cols, 3, class(image1));
    
    for i = 1:size(image2, 1)
        for j = 1:size(image2, 2)
            output(i,j,:)  = image1(i,j,:);
        end
    end

     for i = 1:r1
         for j = 1:c1
             d = [i j 1] * H;
             d = d/d(3);
             di = ceil(d(1)); dj = ceil(d(2));
             output(di,dj,:) = image1(i,j,:);
         end
     end
    %}
end

function warpedImage = warp(im, H, bbox)
    warpedImage = double([]);
    bb = bbox;

    bb_xmin = bb(1);
    bb_xmax = bb(2);
    bb_ymin = bb(3);
    bb_ymax = bb(4);

    [U,V] = meshgrid(bb_xmin:bb_xmax,bb_ymin:bb_ymax);
    [nrows, ncols] = size(U);

    Hi = inv(H);
    
    u = U(:);
    v = V(:);
    x1 = Hi(1,1) * u + Hi(1,2) * v + Hi(1,3);
    y1 = Hi(2,1) * u + Hi(2,2) * v + Hi(2,3);
    w1 = 1./(Hi(3,1) * u + Hi(3,2) * v + Hi(3,3));
    U(:) = x1 .* w1;
    V(:) = y1 .* w1;

    warpedImage(nrows, ncols, 3) = 1;
    warpedImage(:,:,1) = interp2(im(:,:,1),U,V,'bilinear');
    warpedImage(:,:,2) = interp2(im(:,:,2),U,V,'bilinear');
    warpedImage(:,:,3) = interp2(im(:,:,3),U,V,'bilinear');
end

function newBox = getBoundingBox(image, H)
    [w, h, ~] = size(image);
    imgBox = H*[1 w 1 w; 1 1 h h; 1 1 1 1];
    imgBox = [imgBox(1, :) ./ imgBox(3, :); ...
        imgBox(2, :) ./ imgBox(3, :)];
    newBox = [ ...
        ceil(min(1, min(imgBox(1, :)))) ...
        ceil(max(1, max(imgBox(1, :)))) ...
        ceil(min(1, min(imgBox(2, :)))) ...
        ceil(max(1, max(imgBox(2, :))))];
end