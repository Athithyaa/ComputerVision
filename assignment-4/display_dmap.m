function [dcolor] = display_dmap(dmap)
    maxd = max(dmap(:));
    mind = min(dmap(:));

    ndmap = (dmap-mind)/(maxd-mind);

%     dcolor = repmat(ndmap, 1, 1, 3);
% 
%     indices = isnan(dcolor(:,:,1);
%     indices(:,:,2) = 0;
%     indices(:,:,3) = 0;
%     
%     dcolor(isnan(dcolor(:,:,1))) = 1;
%     dcolor(isnan(dcolor(:,:,2))) = 0;
%     dcolor(isnan(dcolor(:,:,3))) = 0;
    
    m1 = ndmap;
    m2 = ndmap;
    m3 = ndmap;
    
    m1(isnan(m1(:,:,1))) = 1;
    m2(isnan(m2(:,:,1))) = 0;
    m3(isnan(m3(:,:,1))) = 0;
    dcolor = cat(3, m1, m2, m3);
    
    imshow(dcolor);
end