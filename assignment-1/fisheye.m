%{
function [outImg] = FishEye(inImg)
    [rows, cols, ch] = size(inImg);
    outImg = zeros(rows, cols, ch, class(inImg));
    
    for y = 1:rows
        ny = ((2*y)/rows)-1;
        for x = 1:cols
            nx = ((2*x)/cols)-1;
            
            % distance to the center
            r = sqrt(nx^2 + ny^2);
            
            if(r < 0.0 || r > 1.0)
                continue;
            end
            
            nr = sqrt(1.0 - r^2);
            nr = (r + (1.0-nr))/2.0;
            
            if(nr <= 1.0)
                theta = atan(ny/ nx);
                nxn = nr * cos(theta);
                nyn = nr * sin(theta);
                
                x2 = uint8(((nxn+1) * cols)/2.0);
                y2 = uint8(((nyn+1) * rows)/2.0);
                
                if(x2 <= cols && y2 <= rows)
                    outImg(y,x, :) = inImg(y2, x2, :);
                end
            end 
        end
    end
    %}

function [out] = FishEye(in)
    thresh = 1;
    K = 0.1;
    width = size(in, 1);
    height = size(in, 2);
    
    centerX = width/2;
    centerY = height/2;

    xshift = calc_shift(0,centerX-1,centerX,K);
    newcenterX = width-centerX;
    xshift_2 = calc_shift(0,newcenterX-1,newcenterX,K);

    yshift = calc_shift(0,centerY-1,centerY,K);
    newcenterY = height-centerY;
    yshift_2 = calc_shift(0,newcenterY-1,newcenterY,K);
    xscale = (width-xshift-xshift_2)/width;
    yscale = (height-yshift-yshift_2)/height;
    
    out = zeros(height, width, 3, class(in));
    for j = 1:height
        for i = 1:width
          x = getRadialX(i,j,centerX,centerY,K, xscale, yscale,xshift, yshift);
          y = getRadialY(i,j,centerX,centerY,K, xscale, yscale,xshift, yshift);
          
          % nearest neighbor sampling. Might want to use bilinear sampling
          % for better quality image
          tx = max(ceil(x), 1);
          ty = max(ceil(y), 1);
          
          %fprintf('%d %d %d %d | %d %d %d %d\n', tx, ty, i, j, height, width, size(in,1), size(in,2));
          if tx >=0 && tx < width && ty >=0 && ty < height
            out(i,j, :) = in(tx,ty, :);
          end
        end
    end
    
    
function val = getRadialX(x, y, cx, cy, k, xscale, yscale,xshift, yshift)
      x = (x*xscale+xshift);
      y = (y*yscale+yshift);
      val = x+((x-cx)*k*((x-cx)*(x-cx)+(y-cy)*(y-cy)));

function val = getRadialY(x, y, cx, cy, k, xscale, yscale,xshift, yshift)
      x = (x*xscale+xshift);
      y = (y*yscale+yshift);
      val = y+((y-cy)*k*((x-cx)*(x-cx)+(y-cy)*(y-cy)));

function val = calc_shift(x1, x2, cx, k)
    thresh = 1;
      x3 = x1+(x2-x1)*0.5;
      res1 = x1+((x1-cx)*k*((x1-cx)*(x1-cx)));
      res3 = x3+((x3-cx)*k*((x3-cx)*(x3-cx)));

      if(res1>-thresh && res1 < thresh)
        val = x1;
        return;
      end
      if(res3 < 0)
        val = calc_shift(x3,x2,cx,k);
      else
        val = calc_shift(x1,x3,cx,k);
      end

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
     
function [out] = imageWarp(in)
     [rows, cols, ch] = size(in);
     out = zeros(rows, cols, ch, class(in));
     
     midx = rows/2;
     midy = cols/2;
     
      for y = 1:rows
        for x = 1:cols
            dx = x - midx;
            dy = y - midy;
            
            tx = x; % warp along y axis
            %tx = max(ceil(sign(dx)*(dx)^2/midx + midx), 1);
            
            
            %ty = y; % warp along x axis
            ty = max(ceil(sign(dy)*(dy)^2/midy + midy), 1);
            
            if tx >=0 && tx < cols && ty >=0 && ty < rows
                out(y,x, :) = in(ty, tx, :);
            end
        end
      end
     
function [out] = Swirl(in)
    [rows, cols, ch] = size(in);
    out = zeros(rows, cols, ch, class(in));
    
    midx = rows/2;
    midy = cols/2;
    
    k = 100;
    
    for y = 1:rows
        for x = 1:cols
            [theta, rho] = cart2pol(x-midx, y-midy);
            phi = theta + (rho/k);
            [tx, ty] = pol2cart(phi, rho);
            
            tx = max(ceil(tx+midx), 1);
            ty = max(ceil(ty+midy), 1);
            
            if tx >=0 && tx < cols && ty >=0 && ty < rows
                out(y,x, :) = in(ty, tx, :);
            end

        end
    end