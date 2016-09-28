function pts = ginput2(n)
    pts = zeros(n, 2);
    hold on
    for i=1:n
        [yc, xc] = ginput(1);
        pts(i,:) = [xc, yc];
        plot(pts(:,2), pts(:,1), 'r+');
    end
    hold off
end