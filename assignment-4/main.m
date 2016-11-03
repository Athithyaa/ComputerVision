%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 4
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% task-1

str1 = 'horseback';
str2 = 'snowflake';

str1 = 'thisisatest';
str2 = 'testing123testing';

result = lcs(str1, str2);
fprintf(' %s\n', result);

% task-2
left = imreadgray('stereo-pairs/teddy/imL.png');
right = imreadgray('stereo-pairs/teddy/imR.png');

maxDisp = 64;
occ = 0.01;

d = stereoDP(left, right, maxDisp, occ);
mind = min(d(:));
maxd = max(d(:));

subplot(121);
imshow(d, [mind maxd]);
title('Disparity map');

subplot(122);
display_dmap(d);
title('Disparity map with NaN pixels set to red');