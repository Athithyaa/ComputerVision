%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 4
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dcolor] = display_dmap(dmap)
    maxd = nanmax(dmap(:));
    mind = nanmin(dmap(:));

    ndmap = double(dmap-mind)./double(maxd-mind);

%     dcolor = repmat(ndmap, 1, 1, 3);
% 
%     indices = isnan(dcolor(:,:,1);
%     indices(:,:,2) = 0;
%     indices(:,:,3) = 0;
%     
%     dcolor(isnan(dcolor(:,:,1))) = 1;
%     dcolor(isnan(dcolor(:,:,2))) = 0;
%     dcolor(isnan(dcolor(:,:,3))) = 0;
    
    red = ndmap;
    green = ndmap;
    blue = ndmap;
    
    red(isnan(red(:,:,1))) = 1;
    green(isnan(green(:,:,1))) = 0;
    blue(isnan(blue(:,:,1))) = 0;
    dcolor = cat(3, red, green, blue);
    
    imshow(dcolor);
end