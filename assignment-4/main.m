% task-1

% str1 = 'horseback';
% str2 = 'snowflake';
% result = lcs(str1, str2);
% fprintf(' %s\n', result);

% task-2
% left = rgb2gray(imread('stereo-pairs/tsukuba/imL.png'));
% right = rgb2gray(imread('stereo-pairs/tsukuba/imR.png'));
left = imread('sr.pgm');
right = imread('sl.pgm');

maxDisp = 64;
occ = 0.01;

d = stereoDP(left, right, maxDisp, occ);
mind = min(d(:));
maxd = max(d(:));

imshow(d, [mind maxd]);