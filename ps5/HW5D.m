%Name:          Yue
%ID:            861131461
%Due data:      Nov 14
%Course:        Cs 229
%AssignmentNo.: PS 5D

clc;
clear;
load class2d.ascii

X = class2d(:,1:2);
Y = class2d(:,3);
Len = size(X,1);
count = 0;

[xx, yy] = meshgrid(-8:0.3:8, -4:0.3:12);
Input = [xx(:),yy(:)];
Len2 = size(Input, 1);

for k = [1 3 7 15] %k-nearest
    count = count+1;
    
    for i = 1:Len2
        for j = 1:Len
            dis(j) = sum((Input(i,:)-X(j,:)).^2);
        end
        [value id] = sort(dis);
        
        Output(i) = sum(Y(id(1:k)))/k;
    end
   
    subplot(2, 2, count);
    title([num2str(k), '-Nearest Neighbor']);
    axis([-8 8 -4 12]);
    hold on;
    plot(class2d(class2d(:,3) ==1, 1), class2d(class2d(:,3) == 1,2), 'bx');
    plot(class2d(class2d(:,3) ==0, 1), class2d(class2d(:,3) == 0,2), 'ro');

    Output = reshape(Output, length(xx), length(xx));

    [c,h] = contourf(xx,yy,Output, [-Inf 0.4 0.5 0.6 Inf]);
    ch = get(h, 'Children');
    for i = 1:length(ch)
        if (get(ch(i), 'CData')<0.5)
            set(ch(i), 'FaceColor', [0.8 0.6 0.6]);
        else
            set(ch(i), 'FaceColor', [0.6 0.6 0.8]);
        end
    end;
    plot(class2d(class2d(:,3) ==1, 1), class2d(class2d(:,3) == 1,2), 'bx');
    plot(class2d(class2d(:,3) ==0, 1), class2d(class2d(:,3) == 0,2), 'ro');
    
end

