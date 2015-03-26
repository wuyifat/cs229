% Name: Yi Wu
% SID: 861028074
% Date: 11/19/2014
% Course: CS 229
% Assignment number: PS6

load -ascii class2d.ascii
% take the first two columns and append a column of 1 in the head to be x
X = class2d(:,1:2);
% take the last column to be y
Y = class2d(:,3);

for poly = [true,false]
% -------------part a--------------------
d = 2;
C = 10;
sigma = 1;
if poly
    % --- poly kernal --
    % calculate the polynomial k matrix
    kmp = km_poly(X,X,d);
    % train the SVM
    [alpha, b] = solvesvm(kmp, Y, C);
    figure;
    plotsvm
    title('SVM with poly kernel, d = 2, c = 1, C = 10');
else
    % --- radial kernal ---
    % calculate the radial k matrix
    kmr = km_radial(X,X,sigma);
    % train the SVM
    [alpha, b] = solvesvm(kmr, Y, C);
    figure;
    plotsvm
    title('SVM with RBF kernel, \sigma = 1, C = 10');
end;


% -------------part b--------------------
n = 10;
dim = size(X,1);

% use C_Y to record y value for poly kernal
C_Y = zeros(size(-4:0.5:4))';
for d = 1:3
    if d == 1
        sigma = 0.5;
    end;
    if d == 2
        sigma = 1;
    end;
    if d == 3
        sigma = 5;
    end;
    for k = 1:5
        id = randperm(dim);
        Cid = 0;
        for C = 10.^(-4:0.5:4)
            Cid = Cid + 1;
            C_acc = 0;
            for gid = 1:n
                train_X = X([1:8*(gid-1), (8*gid+1):end],:);
                train_Y = Y([1:8*(gid-1), (8*gid+1):end],:);
                test_X = X((1+8*(gid-1)):8*gid,:);
                test_Y = Y((1+8*(gid-1)):8*gid,:);
                if poly
                    kmp = km_poly(train_X,train_X,d);
                    [alpha, b] = solvesvm(kmp, train_Y, C);
                    km = km_poly(test_X, train_X,d);
                else
                    kmr = km_radial(train_X,train_X,sigma);
                    [alpha, b] = solvesvm(kmr, train_Y, C);
                    km = km_radial(test_X, train_X,sigma);
                end;
                temp_Y = km * alpha + b * ones(size(test_X,1),1);
                temp_Y(temp_Y>0) = 1;
                temp_Y(temp_Y<=0) = -1;
                diff_Y = temp_Y - test_Y;
                C_acc = C_acc + nnz(diff_Y);
            end;
            C_Y(Cid) = C_Y(Cid) + C_acc;
        end;
    end;
    % find the min C_Y
    C_Y = C_Y / (n*k);
    C_val = 10.^(-4:0.5:4);
    [CM,CI] = min(C_Y);
    C = C_val(CI);
    if poly
    % calculate the polynomial k matrix on the whole dataset
        km = km_poly(X,X,d);
    else
    % calculate the radial k matrix on the whole dataset        
        km = km_radial(X,X,sigma);
    end;
    % train the SVM
    [alpha, b] = solvesvm(km, Y, C);
    figure;
    subplot(1,2,1);
    semilogx(C_val,C_Y);
    subplot(1,2,2);
    plotsvm
    if poly
        title(['poly, d = ',num2str(d), ', c = 1']);
    else
        title(['radial, \sigma = ', num2str(sigma)]);
    end;
end;

end;