% THIS CODE IS NOT COMPLETE.
% I took it out of my framework which is more general than you need,
%   so I had to strip some parts out.  See comments below for
%   how to fill in

% take the first two columns and append a column of 1 in the head to be x
X = class2d(:,1:2);
% take the last column to be y
Z = class2d(:,3);
h1 = plot(X(Z==1,1),X(Z==1,2),'bx');
hold on;
h2 = plot(X(Z==-1,1),X(Z==-1,2),'ro');
axis equal;

npts = 100;
v = axis;
[x,y] = meshgrid(v(1):(v(2)-v(1))/npts:v(2),v(3):(v(4)-v(3))/npts:v(4));
[nx,ny] = size(x);
% FILL IN HERE:  Set Y to be the vector of values from SVM on the points
%  [reshape(x,nx*ny,1) reshape(y,nx*ny,1)]
%  NOTE: do *not* do this in a loop.  Save time, write it as a matrix
%     expression
% find the k matrix using polynomial kernal
if poly
    kmp = km_poly([reshape(x,nx*ny,1) reshape(y,nx*ny,1)], X,d);
    Z = kmp * alpha + b * ones(nx*ny,1);
else
    kmr = km_radial([reshape(x,nx*ny,1) reshape(y,nx*ny,1)], X, sigma);
    Z  = kmr * alpha + b * ones(nx*ny,1);
end;

Z = reshape(Z,nx,ny);
map = [ 1.000 0.625 0.625 ;
        0.875 0.625 0.750 ;
        0.750 0.625 0.875 ;
        0.625 0.625 1.000 ;
       ];
colormap(map);
[c,h] = contourf(x,y,Z,[-Inf -1.0 0 1.0 Inf]);

ch = get(h,'Children');  % this statement doesn't work on Matlab2014
			% if someone can find one that does, please let me know!
for i=1:length(ch)
    v = get(ch(i),'FaceVertexCData');
    if (v>=1)
        set(ch(i),'FaceColor',[0.625 0.625 1.0]);
    elseif (v>=0)
        set(ch(i),'FaceColor',[0.75 0.625 0.875]);
    elseif (v<-1)
        set(ch(i),'FaceColor',[1.0 0.625 0.625]);
    else
        set(ch(i),'FaceColor',[0.875 0.625 0.75]);
    end;
    set(ch(i),'LineWidth',0.5);
end;
[cc,hh] = contour(x,y,Z,[0 0],'LineColor',[0 0 0],'LineWidth',3.0);

uistack([h1; h2],'top');
% FILL IN HERE: Set sv to be only the support vectors
sv = X((alpha~=0),:);

plot(sv(:,1),sv(:,2),'ko','MarkerSize',10);
hold off;
