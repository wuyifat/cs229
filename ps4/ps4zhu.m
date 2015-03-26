% Yi Zhu
% SID 860950381
% 11/07/2014
% CS229
% PS4

load -ascii class2d.ascii
X=[ones(80,1) class2d(:,1) class2d(:,2)];
Y=class2d(:,3);

for layer=[2,3],
    for unit=[1,5,20],
        for lambda=[0.001,0.01,0.1],
w1=rand(unit,size(X,2))*2-1;
w2=rand(1,unit+1)*2-1;
w1_old=rand(unit,size(X,2))*2-1;
w2_old=rand(1,unit+1)*2-1;
iteration=0;
beta1=1;beta2=1;     % Initialzation: assign w1, w2 random values

while norm(w1-w1_old)>0.001 || norm(w2-w2_old)>0.001    % Convergence criteria
    iteration=iteration+1;
    eta=beta1/(beta2+iteration);
    w1_old=w1;w2_old=w2;    % Temperately save old w1 and w2 for comparison
    dw1=zeros(size(w1));dw2=zeros(size(w2));
    for i=[1:80],
        eta=1/(2+i);
        a1=w1*X(i,:)';
        g=1./(1+exp(-a1));
        a2=w2*[1;g];
        f=1./(1+exp(-a2));
        delta2=f-Y(i,:);
        delta1=(w2'*delta2).*[1;(exp(-a1)./(1+exp(-a1)).^2)];
        delta1=delta1(2:end,:);
        dw1=dw1-eta*delta1*X(i,:);  % delta_w1 change
        dw2=dw2-eta*delta2.*[1 g'];  % delta_w2 change
    end;
    w1=w1+dw1/80-eta*lambda*w1;
    w2=w2+dw2/80-eta*lambda*w2;
end;

plot(class2d(find(class2d(:,3)==1),1),class2d(find(class2d(:,3)==1),2),'bx')    % Plot the positive training points
hold on;
plot(class2d(find(class2d(:,3)==0),1),class2d(find(class2d(:,3)==0),2),'ro')    % Plot the negative training points
axis equal;
d=axis;
[x,y]=meshgrid(d(1):(d(2)-d(1))/100:d(2),d(3):(d(4)-d(3))/100:d(4));    %  101*101 grid
z=zeros(101,101);
for i=1:101,
    for j=1:101,
        a1=w1*[1;x(i,j);y(i,j)];
        g=1./(1+exp(-a1));
        a2=w2*[1;g];
        z(i,j)=1./(1+exp(-a2)); % Value for each grid
    end;
end;

[c,h]=contourf(x,y,z,[-Inf 0.4 0.5 0.6 Inf]);
ch=get(h,'Children');
for i=1:length(ch)
    if(get(ch(i),'CData')<0.5)
        set(ch(i),'FaceColor',[0.8 0.6 0.6]);
    else
        set(ch(i),'FaceColor',[0.6 0.6 0.8]);
    end;
end;

plot(class2d(find(class2d(:,3)==1),1),class2d(find(class2d(:,3)==1),2),'bx')    % Plot the positive training points
hold on;
plot(class2d(find(class2d(:,3)==0),1),class2d(find(class2d(:,3)==0),2),'ro')    % Plot the negative training points
title(strcat('Layer: ',num2str(layer),', Hidden units: [',num2str(unit),'], lambda= ',num2str(lambda),' beta1 = ',num2str(beta1),'beta2 = ',num2str(beta2)));
print(gcf,'-r300','-dpdf',strcat(num2str(layer),num2str(unit),num2str(lambda),'.pdf'));
        end;
    end;
end;