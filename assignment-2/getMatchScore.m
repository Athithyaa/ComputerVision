function match = getMatchScore(des1, des2)
    % For efficiency in Matlab, it is cheaper to compute dot products between
    %  unit vectors rather than Euclidean distances.  Note that the ratio of 
    %  angles (acos of dot products of unit vectors) is a close approximation
    %  to the ratio of Euclidean distances for small angles.
    %
    % distRatio: Only keep matches in which the ratio of vector angles from the
    %   nearest to second nearest neighbor is less than distRatio.
    distRatio = 0.6;   

    % For each descriptor in the first image, select its match to second image.
    des2t = des2';                          % Precompute matrix transpose
    for i = 1 : size(des1,1)
        dotprods = des1(i,:) * des2t;        % Computes vector of dot products
        [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

        % Check if nearest neighbor has angle less than distRatio times 2nd.
        if (vals(1) < distRatio * vals(2))
            match(i) = indx(1);
        end
    end
end