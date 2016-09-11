function [out] = Sine(in)
    [rows, cols, ch] = size(in);
     out = zeros(rows, cols, ch, class(in));
 
     % wave1:x(u,v)=u+20sin(2?v/128);y(u,v)=v;
     for y = 1:rows
        for x = 1:cols
            % wave along y-axis
            %tx = max(round(x + 20*sin(2*pi*y/128)), 1);
            %ty = y;
            
            % wave along x-axis
            ty = max(round(y + 20*sin(2*pi*x/128)), 1);
            tx = x;
            
            if tx >=0 && tx < cols && ty >=0 && ty < rows
                out(y,x, :) = in(ty, tx, :);
            end
        end
      end