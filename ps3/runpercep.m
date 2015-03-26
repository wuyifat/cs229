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

% do some initiations..
w_old = [0;0;0];
w_new = w_old;
n = size(x,1);
rate = 0.1;
loop = 0;

% plot the dots
plot(class2d(class2d(:,3)==1,1),class2d((class2d(:,3)==1),2),'bx');
hold on;
plot(class2d((class2d(:,3)==-1),1),class2d((class2d(:,3)==-1),2),'ro');
hold on;
legend('positive','negative');
xlabel('x1');
ylabel('x2');
title('perceptron learning');
hold on;

while true,
    loop = loop + 1;
    w_old = w_new;
    for i = (1:n),
        % If the point the on the wrong side, update w
        cre = x(i,:) * w_new * y(i);
        if cre <= 0,
            w_new = w_new + rate * y(i) * x(i,:)';
        end;
        
        % draw the line and delete it after 0.01s
        h = drawline([w_new(2),w_new(3)],w_new(1));
        if h ~= -1,
            h.Color = 'black';
            pause(0.01);
            delete(h);
        end;
        
    end;

    % If the difference between w_new and w_old is not large, stop and
    % break.
    if w_old == w_new,
        break;
    end;
    
    % update the learning rate
    rate = rate * 0.8;
end;

h = drawline([w_new(2),w_new(3)],w_new(1));
h.Color = 'black';
hold off;

