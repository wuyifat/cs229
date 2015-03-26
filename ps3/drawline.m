function h = drawline(w,b)
% drawline(w,b)
%
% draws a line for the equation x'*w + b = 0
% assumes that the current axes are set up
% correctly and only plots the part of the line
% that overlaps on the current axes
% returns a handle to the line (or -1 if the
%  line does not overlap with the plot)

limits = axis;
mnx = limits(1);
mxx = limits(2);
mny = limits(3);
mxy = limits(4);
if (w(2)==0.0)
    y1 = inf;
    y2 = inf;
else 
    y1 = (-b-mnx*w(1))/w(2);
    y2 = (-b-mxx*w(1))/w(2);
end;
if (w(1)==0.0)
    x1 = inf;
    x2 = inf;
else
    x1 = (-b-mny*w(2))/w(1);
    x2 = (-b-mxy*w(2))/w(1);
end;
if (y1<=mxy && y1>=mny)
    if (y2<=mxy && y2>=mny)
        h = line([mnx mxx],[y1 y2]);
    elseif (x1<=mxx && x1>=mnx)
        h = line([mnx x1],[y1 mny]);
    else
        h = line([mnx x2],[y1 mxy]);
    end;
elseif (y2<=mxy && y2>=mny)
    if (x1<=mxx && x1>=mnx)
        h = line([mxx x1],[y2 mny]);
    else
        h = line([mxx x2],[y2 mxy]);
    end;
elseif (x1<=mxx && x1>=mnx && x2<=mxx && x2>=mnx)
    h = line([x1 x2],[mny mxy]);
else
    h = -1;
end;
