%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sunil Baliganahalli Narayana Murthy
% Course number: CSCI 5722 - Computer Vision
% Assignment: 2
% Instructor: Ioana Fleming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Count, H] = ransac(image1, image2)
    % Find SIFT keypoints for each image
    [~, des1, loc1] = sift(image1);
    [~, des2, loc2] = sift(image2);

    score = getMatchScore(des1, des2);
    [pts1, pts2] = getMatchPoints(loc1, loc2, score);
    
    bestFit = 0;
    numIter = 100;
    tolerance = 1;
    % assuming there are equal number of points in pts1, pts2
    % otherwise use min(size(pts,1), size(pts2,1)
    nPoints = size(pts1, 1);
    
    for i = 1:numIter
        % we need 4 points to generate homography. Randomly generate 4
        % indices for getting 4 points
        indices = randi(nPoints, 10, 1);
        p1 = pts1(indices, :);
        p2 = pts2(indices, :);
        
        % compute homography for the subset of points
        h = computeHomography(p1, p2);
        
        % transform the p1 points to p2 frame of reference.
        % Use homography matrix p2 = h*p1
        xs = p1(:,1);
        ys = p1(:,2);
        % create matrix and then multiply rather than doing individually.
        tx = ( h(1,1)*xs + h(1,2)*ys + h(1,3) ) ./ ...
              ( h(3,1)*xs + h(3,2)*ys + h(3,3) );

        ty = ( h(2,1)*xs + h(2,2)*ys + h(2,3) ) ./ ...
              ( h(3,1)*xs + h(3,2)*ys + h(3,3) );
        tp1 = [tx, ty];
        
        % compute least squared distance.
        lsd = ((p2(:,1) - tp1(:,1)).^2 + (p2(:,2) - tp1(:,2)).^2).^(0.5);
        
        
        fit = length(find(lsd < tolerance));
        if fit > bestFit
            bestFit = fit;
            Count = bestFit;
            H = h;
        end
    end
end