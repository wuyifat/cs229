% Name: Yi Wu
% SID: 861028074
% Date: 10/23/2014
% Course: CS 229
% Assignment number: PS2

load -ascii machine.ascii
test_perf = zeros(61,1);
lambda_exp = (-3:0.1:3);
lambda = zeros(size(lambda_exp));



for i = (1:20),
        
        % Randomly take 20% data as training data, and the rest as testing data.
        train_number = floor(size(machine,1) * 0.2);
        blend = randperm(size(machine,1));
        train = machine(blend(1:train_number),:);
        test = machine(blend((train_number + 1):end),:);

        % Normalize the features in training set.
        train_feature = train(:,1:(size(train,2) - 1));
        train_y = train(:, size(train,2));
        feature_mean = mean(train_feature);
        feature_std = std(train_feature);
        train_reg = (train_feature - repmat(feature_mean, [size(train_feature,1),1]))...
            ./ repmat(feature_std, [size(train_feature,1),1]);

        % Normalize the features in testing set with training mean and std.
        test_feature = test(:,1:(size(test,2) - 1));
        test_y = test(:, size(test,2));
        test_reg = (test_feature - repmat(feature_mean, [size(test_feature,1),1]))...
            ./ repmat(feature_std, [size(test_feature,1),1]);

        % Add a column of 1 to training and testing feature
        train_reg_feature = [ones(size(train,1),1), train_reg];
        test_reg_feature = [ones(size(test,1),1), test_reg];

        % Calculate ridge w
        eye_m = eye(size(train_reg_feature,2));
        % Set the first element to be 0 so it doesn't penalize bias.
        eye_m(1) = 0;
        
   for k = (1:size(lambda_exp,2)),
        lambda(1,k) = 10^(lambda_exp(k));
        w = (train_reg_feature' * train_reg_feature + lambda(1,k) * eye_m)^(-1) * train_reg_feature' * train_y;

        % Calculate the performance on testing set
        perf = test_y - test_reg_feature * w;
        test_one_perf = sum(perf.*perf) / size(test,1);
        test_perf(k) = test_one_perf + test_perf(k);

    end;

end;

test_perf = test_perf / 20;    % Take the mean of 20 iterations
semilogx(lambda, test_perf);
hold on;
legend('performance VS lambda');
xlabel('lambda');
ylabel('average performance');
hold off;
