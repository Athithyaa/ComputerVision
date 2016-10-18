%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 3
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [point3d] = computeDepth(dmap, stereo)
    [X,Y] = meshgrid(1:1:size(dmap,2), 1:1:size(dmap, 1));
    fx = stereo.CameraParameters1.FocalLength(1);
    flen = fx / .25;
    p1 = stereo.CameraParameters1.PrincipalPoint;
    p2 = stereo.CameraParameters2.PrincipalPoint;
    
    B = sqrt(sum((p1-p2).^2));
    point3d = cat(3, X,Y,(flen*B) ./ dmap);
end