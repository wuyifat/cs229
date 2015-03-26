% Name: Yi Wu
% SID: 861028074
% Date: 10/28/2014
% Course: CS 229
% Assignment number: PS3

load -ascii class2d.ascii
% take the first two columns and append a column of 1 in the head to be x
x = class2d(:,1:2);
x = [ones(size(x,1),1),x];
% take the last column to be y
y = class2d(:,3);

% do some initiations...
w_old = [0;0;0];
threshold = 0.0001;
loop = 0;

% plot the dots
plot(class2d(class2d(:,3)==1,1),class2d((class2d(:,3)==1),2),'bx');
hold on;
plot(class2d((class2d(:,3)==-1),1),class2d((class2d(:,3)==-1),2),'ro');
hold on;
legend('positive','negative');
xlabel('x1');
ylabel('x2');
title('logistic regression');
hold on;

while true,
    loop = loop + 1;
    
    % calculate the new w
    R_matrix = R(x,w_old,y);
    z_matrix = z(x,w_old,y,R_matrix);
    w_new = (x' * R_matrix * x)^(-1) * x' * R_matrix * z_matrix;
    
    h = drawline([w_new(2),w_new(3)],w_new(1));
    if h ~= -1,
        h.Color = 'black';
        pause(1);
        delete(h);
    end;
    
    % calculate the difference between w_new and w_old. If it's small,
    % break.
    w_diff = w_new - w_old;
    diff = sqrt(sum(w_diff .* w_diff)); 
    if diff < threshold,
        break;
    end;
    
    w_old = w_new;
end;

h = drawline([w_new(2),w_new(3)],w_new(1));
h.Color = 'black';
hold off;
