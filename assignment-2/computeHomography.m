function H = computeHomography(p1, p2)
    n = size(p1, 1);
    
    A = zeros(2*n, 9);
    for i = 1:n
        x1 = p1(i, 1);
        y1 = p1(i, 2);
        X1 = p2(i, 1);
        Y1 = p2(i, 2);
        A(2*i-1,:) = [-x1, -y1, -1, 0, 0, 0, x1*X1, y1*X1, X1];
        A(2*i,:)   = [0, 0, 0, -x1, -y1, -1, x1*Y1, y1*Y1, Y1];
    end
    
    [~, ~, V] = svd(A);
    H = reshape(V(:,end), 3, 3);
end