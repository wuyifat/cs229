% Name: Yi Wu
% SID: 861028074
% Date: 10/23/2014
% Course: CS 229
% Assignment number: PS2

load -ascii machine.ascii
j = 0;
test_perf = zeros(61,1);
lambda_exp = (-3:0.1:3);
lambda = zeros(size(lambda_exp));
w = zeros(7,61);

for k = (1:size(lambda_exp,2)),
    lambda(1,k) = 10^(lambda_exp(k));
    j = j + 1;

    train = machine;

    % Normalize the features in training set.
    train_feature = train(:,1:(size(train,2) - 1));
    train_y = train(:, size(train,2));
    feature_mean = mean(train_feature);
    feature_std = std(train_feature);
    train_reg = (train_feature - repmat(feature_mean, [size(train_feature,1),1]))...
        ./ repmat(feature_std, [size(train_feature,1),1]);


    % Add a column of 1 to training and testing feature
    train_reg_feature = [ones(size(train,1),1), train_reg];


    % Calculate ridge w
    eye_m = eye(size(train_reg_feature,2));
    % Set the first element to be 0 so it doesn't penalize bias.
    eye_m(1) = 0;
    w(:,k) = (train_reg_feature' * train_reg_feature + lambda(1,k) * eye_m)^(-1) * train_reg_feature' * train_y;


end;

for i = (1:7),
    semilogx(lambda, w(i,:));
    hold on;
end;

legend('w0','w1','w2','w3','w4','w5','w6');
xlabel('lambda');
ylabel('w');
hold off;