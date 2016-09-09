function [output] = scaleNearest(input, factor)
    [~, ~, channels] = size(input);
    
    % make this generic per channels(like in case of RGBA). for now assumed to be RGB channels
    red_channel = input(:, :, 1);
    green_channel = input(:, :, 2);
    blue_channel = input(:, :, 3);
    
    red_scale = NearestNeighbor(red_channel, factor);
    green_scale = NearestNeighbor(green_channel, factor);
    blue_scale = NearestNeighbor(blue_channel, factor);
    
    output = cat(channels, red_scale, green_scale, blue_scale);
    
function [output] = NearestNeighbor(input, factor)
    [rows, cols] = size(input);
    output = zeros(factor*rows, factor*cols, class(input));
    
    for i=1:factor*rows
        for j=1:factor*cols
            % map from output image location to input image location
            ii = round( (i-1)*(rows-1)/(factor*rows-1)+1 );
            jj = round( (j-1)*(cols-1)/(factor*cols-1)+1 );
            
            % [ii, jj] = sampleNearest(x, y)

            % assign value
            output(i,j) = input(ii,jj);
        end
    end
    
function [ value ] = sampleNearest( x, y)
    % TODO: implement this function