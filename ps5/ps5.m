% Name: Yi Wu
% SID: 861028074
% Date: 11/13/2014
% Course: CS 229
% Assignment number: PS5

load -ascii class2d.ascii
% take the first two columns and append a column of 1 in the head to be x
x = class2d(:,1:2);
% take the last column to be y
y = class2d(:,3);
n = size(x,1);
kMatrix = zeros(n,n);

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
Z = zeros(N,N);
Zk = zeros(N,N,n);
plotID = 0;

close;
%for sigma = 1,
 %   for norm = 1,
for norm = (0:1),
   for sigma = [0.2, 1.0, 5.0],
 %   for norm = [0 1],
        plotID = plotID + 1;

        % calculate the K matrix
        for i = 1:n,
            for j = 1:n,
                kMatrix(i,j) = k(x(i,1),x(i,2),x(j,1),x(j,2),sigma);
            end;
            if norm
                kMatrix(i,:) = kMatrix(i,:)/sum(kMatrix(i,:));
            end
        end;
 %       if norm,
  %          kMatrix = kMatrix ./ repmat(sum(kMatrix,1),[n,1]);
   %     end;
        % calculate the weights
        w = (kMatrix' * kMatrix) \ kMatrix' * y;

        % calculate K vector on each meshgrid
        for i = 1:N,
            for j = 1:N,
                for ci = 1:n,
                    Zk(i,j,ci) = k(x(ci,1),x(ci,2),X(i,j), Y(i,j), sigma);
                end;
            end;
        end;

        % calculate the normalization term
        Zk_sum = sum(Zk,3);

        for i = 1:N,
            for j = 1:N,
                for ki = 1:n,
                    Z(i,j) = Z(i,j) + Zk(i,j,ki) * w(ki);
                end;
            end;
        end;
        if norm,
            Z = Z ./ Zk_sum;
        end;
        
        subplot(2,3,plotID);
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

        scatter(class2d(class2d(:,3)==1,1),class2d((class2d(:,3)==1),2),'bx');
        hold on;
        scatter(class2d((class2d(:,3)==0),1),class2d((class2d(:,3)==0),2),'ro');
     %   hold on;

         if norm,   
            title(['Gaussian kernel ', num2str(sigma), ' normalized']);
         else
             title(['Gaussian kernel ', num2str(sigma), ' unnormalized']);
         end;
    end;
end;

% ---------------- part b -----------------------------------
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
Z = zeros(N,N);
Zk = zeros(N,N,n);

% initialize the 16 centers
center = zeros(16,2);
for i = 1:16,
    range = sort(randperm(n,2));
    len = range(2) - range(1);
    center(i,1) = sum(x(range(1):range(2), 1)) / len;
    center(i,2) = sum(x(range(1):range(2), 2)) / len;
end;

while true,
    center_old = center;
    cMatrix = zeros(80,16);
    group = zeros(16,3);
    for i = 1:n,
        for ci = 1:16,
            cMatrix(i,ci) = (x(i,1) - center(ci,1))^2 + (x(i,2) - center(ci,2))^2;
        end;
    end;
    [val, cid] = sort(cMatrix,2);
  
    for i = 1:n,
        id = cid(i,1);
        group(id,1) = group(id,1) + x(i,1);
        group(id,2) = group(id,2) + x(i,2);
        group(id,3) = group(id,3) + 1;
    end;
    % if there is no point belong to a group, use the mean of some random
    % points as the center.
    for i = 1:16,
        if group(i,3) == 0,
            range = sort(randperm(n,2));
            len = range(2) - range(1);
            group(i,1) = sum(x(range(1):range(2), 1)) / len;
            group(i,2) = sum(x(range(1):range(2), 2)) / len;
            group(i,3) =1;
        end;
    end;
    center = group(:,1:2) ./ repmat(group(:,3),[1,2]);
   
   if center == center_old,
       break;
   end;
end;

plotID = 0;
kMatrix = zeros(n,16);
for sigma = [0.2, 1.0, 5.0],
    for norm = [0 1],
        plotID = plotID + 1;

        % calculate the K matrix
        for i = 1:n,
            for j = 1:16,
                kMatrix(i,j) = k(center(j,1),center(j,2),x(i,1),x(i,2),sigma);
            end;
            if norm,
                kMatrix(i,:) = kMatrix(i,:)/sum(kMatrix(i,:));
            end;
        end;

        % calculate the weights
        w = (kMatrix' * kMatrix) \ kMatrix' * y;

        % calculate K vector on each meshgrid
        for i = 1:N,
            for j = 1:N,
                for ci = 1:n,
                    Zk(i,j,ci) = k(x(ci,1),x(ci,2),X(i,j), Y(i,j), sigma);
                end;
            end;
        end;

        % calculate the normalization term
        Zk_sum = sum(Zk,3);


        for i = 1:N,
            for j = 1:N,
                for ki = 1:16,
                    Z(i,j) = Z(i,j) + Zk(i,j,ki) * w(ki);
                end;
            end;
        end;
        if norm,
            Z = Z ./ Zk_sum;
        end;
        
        subplot(2,3,plotID);
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

        scatter(class2d(class2d(:,3)==1,1),class2d((class2d(:,3)==1),2),'bx');
        hold on;
        scatter(class2d((class2d(:,3)==0),1),class2d((class2d(:,3)==0),2),'ro');
        hold on;
        h = plot(center(:,1),center(:,2),'ko');
        set(h,'MarkerFaceColor', [0 0 0]);

         if norm,   
            title(['Gaussian kernel ', num2str(sigma), ' normalized']);
         else
             title(['Gaussian kernel ', num2str(sigma), ' unnormalized']);
         end;
    end;
end;


% ------------------------ part d ---------------------------------
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



