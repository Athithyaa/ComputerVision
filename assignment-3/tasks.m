%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 3
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% task 1
leftIm = imread('left.bmp');
rightIm = imread('right.bmp');

subplot(221);
dmap = computeDisparity(leftIm, rightIm, 1, 'SSD');
imshow(dmap, [0 64]);
title('SSD window = 1');
colormap jet;

subplot(222);
dmap = computeDisparity(leftIm, rightIm, 3, 'SSD');
imshow(dmap, [0 64]);
title('SSD window = 3');
colormap jet;

subplot(223);
dmap = computeDisparity(leftIm, rightIm, 5, 'SSD');
imshow(dmap, [0 64]);
title('SSD window = 5');
colormap jet;

subplot(224);
dmap = disparity(leftIm, rightIm);
imshow(dmap, [0 64]);
title('Matlab builtin');
colormap jet;

% task 2
figure;

subplot(221);
dmap = computeDisparity(leftIm, rightIm, 3, 'NCC');
imshow(dmap, [0 64]);
title('NCC window = 3');
colormap jet;

subplot(222);
dmap = computeDisparity(leftIm, rightIm, 5, 'NCC');
imshow(dmap, [0 64]);
title('NCC window = 5');
colormap jet;

subplot(223);
dmap = computeDisparity(leftIm, rightIm, 7, 'NCC');
imshow(dmap, [0 64]);
title('NCC window = 7');
colormap jet;

subplot(224);
dmap = disparity(leftIm, rightIm);
imshow(dmap, [0 64]);
title('Matlab builtin');
colormap jet;

% task 3
figure;
wsize = 3;
LR = computeDisparity(leftIm, rightIm, wsize, 'SSD');
RL = fliplr(computeDisparity(fliplr(rightIm), fliplr(leftIm), wsize, 'SSD'));
threshold = 1;
outliers = outlierMap(LR, RL, threshold);

subplot(121);
imshow(outliers);
title('outlier map');

subplot(122);
imshow(LR.*outliers==0);
title('outliers removed from LR disparity');
% task 4
% nothing to do