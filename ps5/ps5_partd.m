clear;
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

% calculate squared distance between each meshgrid and centers
Z = zeros(N,N);
distMatrix = zeros(N,N,n);
for i = 1:N,
    for j = 1:N,
        for c = 1:n,
            distMatrix(i,j,c) = (X(i,j) - x(c,1))^2 + (Y(i,j) - x(c,2))^2;
        end;
    end;
end;

% sort distance
[val, index] = sort(distMatrix,3);

plotID = 0;
for k = [1,3,7,15],
    plotID = plotID + 1;
    for i = 1:N,
        for j = 1:N,
            Z(i,j) = sum(y(index(i,j,2:1+k))) / k;
            if Z(i,j)>0.5,
                Z(i,j) = 1;
            else
                Z(i,j) = 0;
            end;
        end;
    end;
    
    subplot(2,2,plotID);
    [c,h] = contourf(X,Y,Z,[-Inf 0.4 0.5 0.6 Inf]);
    ch = get(h, 'Children');
    for i=1:length(ch)
        if (get(chi(i), 'CData')<0.5)
            set(ch(i), 'FaceColor', [0.8 0.6 0.6]);
        else
            set(ch(i), 'FaceColor', [0.6 0.6 0.8]);
        end;
    end;
    hold on;
    
    title(['k-nearest neighbor, k = ', num2str(k)]);

    scatter(class2d(class2d(:,3)==1,1),class2d((class2d(:,3)==1),2),'bx');
    hold on;
    scatter(class2d((class2d(:,3)==0),1),class2d((class2d(:,3)==0),2),'ro');
    %hold on;
end;



