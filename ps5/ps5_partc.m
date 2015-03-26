load -ascii class2d.ascii
% take the first two columns and append a column of 1 in the head to be x
x = class2d(:,1:2);
% take the last column to be y
y = class2d(:,3);
n = size(x,1);

scatter(class2d(class2d(:,3)==1,1),class2d((class2d(:,3)==1),2),'bx');
hold on;
scatter(class2d((class2d(:,3)==0),1),class2d((class2d(:,3)==0),2),'ro');
hold on;

axis equal;
v = axis;
dx = (v(2) - v(1)) / 100;
dy = (v(4) - v(3)) / 100;
[X, Y] = meshgrid(v(1):dx:v(2), v(3):dy:v(4));
N = size(X,1);