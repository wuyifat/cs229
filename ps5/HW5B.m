%Name:          Yue
%ID:            861131461
%Due data:      Nov 14
%Course:        Cs 229
%AssignmentNo.: PS 5B

clear;
clc;

load class2d.ascii;

X = class2d(:,1:2);
Len = size(X,1);
Num_C = 16;
INF = 10000000;

Cx = -8+16*rand(Num_C,1);
Cy = -4+16*rand(Num_C,1);
C = [Cx, Cy];
Crownd = zeros(Num_C,Len);
Delta_C = ones(Num_C,2);

while sum(abs(Delta_C)) > 0.000000001
   Count = zeros(1,Num_C);
   Old_C = C;
   
   for i = 1: Len
       dis = INF;
       for j = 1:Num_C
           currentdis = sum((X(i,:)-C(j,:)).^2);
           if currentdis < dis
               dis = currentdis;
               lable = j;
           end
       end
       Count(lable) = Count(lable)+1;
       Crowd(lable, Count(lable)) = i;
   end
   
   for j = 1:Num_C
       if Count(j) < 2
           C(j,:) = [-8+16*rand(1), -4+16*rand(1)];
       else
           C(j,:) = mean(X(Crowd(j,1:Count(j)),:));
       end
   end
   
   Delta_C = C-Old_C;
end

figure;
axis([-8 8 -4 12]);
hold on;
plot(class2d(class2d(:,3) ==1, 1), class2d(class2d(:,3) == 1,2), 'bx');
plot(class2d(class2d(:,3) ==0, 1), class2d(class2d(:,3) == 0,2), 'ro');
plot(C(:,1), C(:,2), 'y+');

%%%%%%%%%%%K-Mean End%%%%%%%%%%%%%%%%%%%%%%%%%%
Y = class2d(:,3);
count = 0;

for sigma = [0.2 1.0 5.0]
for normalize = [0 1]
count = count+1;
for i = 1:Len
    for j = 1:Num_C
        Phi(i,j) = exp(-sum(((X(i,:)-C(j,:)).^2)/(2*(sigma.^2))));
    end
    if normalize
        Phi(i,:) = Phi(i,:)/sum(Phi(i,:));
    end
end

W = (Phi'*Phi)\Phi'*Y;
subplot(2, 3, count);
if normalize   
    title(['Gaussian kernel ', num2str(sigma), ' normalized']);
else
    title(['Gaussian kernel ', num2str(sigma), ' unnormalized']);
end;
axis([-8 8 -4 12]);
hold on;
plot(class2d(class2d(:,3) ==1, 1), class2d(class2d(:,3) == 1,2), 'bx');
plot(class2d(class2d(:,3) ==0, 1), class2d(class2d(:,3) == 0,2), 'ro');

[xx, yy] = meshgrid(-8:0.3:8, -4:0.3:12);
Input = [xx(:),yy(:)];

for i = 1:size(Input,1)
    for j = 1:Num_C
        Phi_temp(j) = exp(-sum(((Input(i,:)-C(j,:)).^2)/(2*(sigma.^2))));
    end
    if normalize
        Phi_temp = Phi_temp/sum(Phi_temp);
    end
    Output(i) = W'*Phi_temp';
end

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
h = plot(C(:,1), C(:,2), 'ko');
set(h, 'MarkerFaceColor', [0 0 0]);
end
end

