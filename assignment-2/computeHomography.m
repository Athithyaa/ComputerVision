function H = computeHomography(p1, p2)
    n = size(p1, 1);
    p = zeros(n*3, 9);
    pp = zeros(n*3, 1);
    
    % lambda * p = H * pp
    for i = 1:n
        p(3*(i-1)+1, 1:3) = [p2(i,:), 1];
        p(3*(i-1)+2, 4:6) = [p2(i,:), 1];
        p(3*(i-1)+3, 7:9) = [p2(i,:), 1];
        pp(3*(i-1)+1:3*(i-1)+3) = [p1(i,:), 1];
    end
    
    x = (p\pp);
    H = reshape(x, [3 3]);
end