function plotdec(testfn,npts,varargin)

v = axis;
[x,y] = meshgrid(v(1):(v(2)-v(1))/npts:v(2),v(3):(v(4)-v(3))/npts:v(4));
[nx,ny] = size(x);
z = testfn([reshape(x,nx*ny,1) reshape(y,nx*ny,1)],varargin{:});
z = reshape(z,nx,ny);
hold on;
[c,h] = contourf(x,y,z,[-Inf 0.4 0.5 0.6 Inf]);
ch = get(h,'Children');
for i=1:length(ch)
    if (get(ch(i),'CData')<0.5)
        set(ch(i),'FaceColor',[0.8 0.6 0.6]);
    else
        set(ch(i),'FaceColor',[0.6 0.6 0.8]);
    end;
end;
