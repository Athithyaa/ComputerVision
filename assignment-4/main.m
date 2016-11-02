%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 4
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% task-1

str1 = 'horseback';
str2 = 'snowflake';
result = lcs(str1, str2);
fprintf(' %s\n', result);

% task-2
left = imreadgray('stereo-pairs/tsukuba/imR.png');
right = imreadgray('stereo-pairs/tsukuba/imL.png');

maxDisp = 64;
occ = 0.01;

d = stereoDP(left, right, maxDisp, occ);
mind = min(d(:));
maxd = max(d(:));

subplot(121);
imshow(d, [mind maxd]);

subplot(122);
display_dmap(d);