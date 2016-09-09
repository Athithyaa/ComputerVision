function imgFilt = applyFilter(img, kernel)
    [rows, cols, ~] = size(img);
    k_size = size(kernel, 1);
    
    % calculate the padding
    pad = (k_size - 1)/2;
    
    % pad the image
    img(rows+2*pad, cols+2*pad) = 0;
    img = circshift(img, [pad pad]);
    
    % convert the uint8 image to double. otherwise matlab won't 
    % allow you multiple matrices of two different classes
    img = im2double(img);
    
    % calculate the inverse kernel.
    invKernel = kernel(k_size:-1:1, k_size:-1:1);
    
    % calculate the median using the kernel
    imgFilt = zeros(rows, cols);
    for y = 1:rows
        for x=1:cols
            part = img(y:(y+2*pad), x:(x+2*pad));
            imgFilt(y,x,1)=sum(sum(part .* invKernel));
        end
    end