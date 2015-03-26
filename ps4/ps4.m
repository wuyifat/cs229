% Name: Yi Wu
% SID: 861028074
% Date: 11/07/2014
% Course: CS 229
% Assignment number: PS4

load -ascii class2d.ascii
% take the first two columns and append a column of 1 in the head to be x
x = class2d(:,1:2);
% take the last column to be y
y = class2d(:,3);

% plot the dots
plot(class2d(class2d(:,3)==1,1),class2d((class2d(:,3)==1),2),'bx');
hold on;
plot(class2d((class2d(:,3)==0),1),class2d((class2d(:,3)==0),2),'ro');
hold on;

% do some initiations..
beta1 = 2;
beta2 = 10;
for layer_num = [2,3],
    for hnode_num = [1,5,20],
        for lambda = [0.001, 0.01, 0.1],
            
            if layer_num > 2,
                more = true;
            else
                more = false;
            end;
            
            % initiate w
            w1 = rand(hnode_num, size(x,2)+1) * 2 - 1;
            if more,
                w2 = rand(hnode_num, hnode_num + 1) * 2 - 1;
            else
                w2 = 0;
            end;
            wf = rand(1, hnode_num + 1) * 2 - 1;
            
            iteration = 0;
            threshold = 0.0001;
            bias = ones(size(x,1),1);

            while true,
                iteration = iteration + 1;
                ita = beta1 / (beta2 + iteration);
                w1_old = w1;
                w2_old = w2;
                wf_old = wf;

                % forward
                z0 = [bias, x];
                a1 = z0 * w1';
                z1 = [bias, g(a1)];
                if more,
                    a2 = z1 * w2';
                    z2 = [bias, g(a2)];
                    af = z2 * wf';
                else
                    af = z1 * wf';
                end;
                    zf = g(af);
                    
                % backward
                deltaf = zf - y;
                if more,
                    delta2 = (deltaf * wf) .* [bias, g_prime(a2)];
                    delta2 = delta2(:, 2:end);
                    delta1 = (delta2 * w2) .* [bias, g_prime(a1)];
                else
                    delta1 = (deltaf * wf) .* [bias, g_prime(a1)];
                end;
                delta1 = delta1(:, 2:end);
                
                % calculate delta_w
                delta_w1 = -ita * delta1' * z0;
                if more,
                    delta_w2 = -ita * delta2' * z1;
                    delta_wf = -ita * deltaf' * z2;
                else
                    delta_wf = -ita * deltaf' * z1;
                end;

                % update w
                w1 = w1 + delta_w1/80 - ita * lambda * w1;
                if more,
                    w2 = w2 + delta_w2/80 - ita * lambda * w2;
                end;
                wf = wf + delta_wf/80 - ita * lambda * wf;

                w1_diff = w1 - w1_old;
                w2_diff = w2 - w2_old;
                wf_diff = wf - wf_old;
                if (norm(w1_diff) + norm(w2_diff) + norm(wf_diff)) < threshold,
                    break;
                end;
            end;


            % plot the contour
            title(['Hidden units : ',num2str(hnode_num),' lambda is ',num2str(lambda)]);
            axis equal;
            v = axis;
            dx = (v(2) - v(1)) / 100;
            dy = (v(4) - v(3)) / 100;
            [X, Y] = meshgrid(v(1):dx:v(2), v(3):dy:v(4));
            Z = findF(X,Y,w1,w2,wf);

            [c,h] = contourf(X,Y,Z,[-Inf 0.4 0.5 0.6 Inf]);
            ch = get(h, 'Children');
            for i=1:length(ch)
                if (get(chi(i), 'CData')<0.5)
                    set(ch(i), 'FaceColor', [0.8 0.6 0.6]);
                else
                    set(ch(i), 'FaceColor', [0.6 0.6 0.8]);
                end;
            end;
            % plot the dots
            plot(class2d(class2d(:,3)==1,1),class2d((class2d(:,3)==1),2),'bx');
            hold on;
            plot(class2d((class2d(:,3)==0),1),class2d((class2d(:,3)==0),2),'ro');
            hold on;
        end;
    end;
end;
