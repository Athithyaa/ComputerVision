function [out] = fisheye(in)
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