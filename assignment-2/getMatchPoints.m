function [pts1, pts2] = getMatchPoints(loc1, loc2, match)
    nMatches = sum(match > 0);
    pts1 = zeros(nMatches, 2);
    pts2 = zeros(nMatches, 2);
    
    for i = 1:size(match, 2)
        if match(i) > 0
            x1 = loc1(i, 1);
            y1 = loc1(i, 2);
            
            x2 = loc2(match(i), 1);
            y2 = loc2(match(i), 2);
            
            pts1(i, :) = [x1, y1];
            pts2(i, :) = [x2, y2];
        end
    end
    
    % remove the blank entries
    pts1(~any(pts1, 2), :) = [];
    pts2(~any(pts2, 2), :) = [];
end