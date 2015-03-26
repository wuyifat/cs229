delta=[-2*pi:0.063:2*pi];
y=sin(delta);
subplot(3,2,1)
plot(y)
% First call to title() needs to be called now to apply to the 1st plot.
title('cos(delta)')  
y=cos(delta);
subplot(3,2,2)
plot(y)
title('sin(delta)') % Now call title() the second time for the 2nd plot.