function plotall(X,Y,fn,ndiv,varargin)

h1 = plot(X(Y==1,1),X(Y==1,2),'bx');
hold on;
h2 = plot(X(Y==0,1),X(Y==0,2),'ro');
axis equal;
plotdec(fn,ndiv,varargin{:});
uistack([h1; h2],'top');
hold off;
