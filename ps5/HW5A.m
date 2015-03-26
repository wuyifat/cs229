%Name:          Yue
%ID:            861131461
%Due data:      Nov 14
%Course:        Cs 229
%AssignmentNo.: PS 5

load class2d.ascii;

X = class2d(:, 1:2);
Y = class2d(:, 3);
C = class2d(:, 1:2);
Len = length(X);
count = 0;

%for sigma = [0.2 1.0 5.0]
%for normalize = [0 1]
for sigma = 1,
for normalize = 1,
count = count+1;
for i = 1:Len
    for j = 1:Len
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
%    Temp2 = 0;
    for j = 1:Len
        Phi_temp(j) = exp(-sum(((Input(i,:)-C(j,:)).^2)/(2*(sigma.^2))));
%        Temp2 = Temp2+W(j)*Phi_temp(j);
    end
    if normalize
        Phi_temp = Phi_temp/sum(Phi_temp);
    end
    Output(i) = W'*Phi_temp';
%    Output(i) = Temp2;
end


%{
A1 = Input*W1;
Z1_temp = 1./(1+exp(-A1));
Z1 = [ones(length(Input),1),Z1_temp];
A2 = Z1*W2;
Output = 1./(1+exp(-A2));

for i = 1:length(Input)
    A1 = W1*Input(i,:)';
    Z1_temp = 1./(1+exp(-A1));
    Z1 = [1; Z1_temp];
    
    A2 = W2*Z1;
    Output(i) = 1./(1+exp(-A2)); %predict value
end
%}
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
end

