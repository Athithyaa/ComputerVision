str1 = 'horseback';
str2 = 'snowflake';

% result = lcs(str1, str2);
% fprintf(' %s\n', result);

left = rgb2gray(imread('tim2.png'));
right = rgb2gray(imread('tim6.png'));
maxDisp = 64;
occ = 0.01;

d = stereoDP(left, right, maxDisp, occ);
mind = min(d(:));
maxd = max(d(:));

imshow(d, [mind maxd]);