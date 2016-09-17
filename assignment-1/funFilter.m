%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 1
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outImg] = funFilter(current_img)
    funfilter = menu('choose fun filter', 'Fish eye', 'Image warp', ...
               'Sine', 'Swirl');
    switch funfilter
        case 1
            outImg = fisheye(current_img);
        case 2
            outImg = imageWarp(current_img);
        case 3
            outImg = sine(current_img);
        case 4
            outImg = swirl(current_img);
    end