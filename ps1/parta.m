% Name: Yi Wu
% SID: 861028074
% Date: 10/14/2014
% Course: CS 229
% Assignment number: PS1

m = 100;

for n = [50 100 500],
% Store the smallest distance of each dimension in vector min_dis_dim. The first column is the 
% dimension, the second column stores the min distance of that dimension.
min_dis_dim = zeros(10,2);
min_dis_dim(:,1) = [10 20 30 40 50 60 70 80 90 100];

% Loop through all the desired dimensions and find the min distance
for k = 1:10,
   % Set the dimension to be the desired value
   d = min_dis_dim(k, 1);

   % Store the smallest distance of each set in vector min_dis_each_set
   min_dis_each_set = zeros(m,1);

   for j = 1:m,

      % Store the smallest distance of each point in vector min_dis_this_set
      min_dis_this_set = zeros(n,1);

      % Generate n random points
      pts = randn(n,d);
      pts = pts.*repmat((rand(n,1).^(1/d))./sqrt(sum(pts.*pts,2)),[1 d]);

      % Find the smallest distance of each point
      for i = 1:n,
         diff = pts - repmat(pts(i,:),[n 1]);              % calculate the vector substraction between i-th vector and the others
         distance = sum((diff.^2),2);        % calculate the distance between i-th point and the others
         % Get non-zero min among the distances and store it in vector min_dis_this_set
         distance(~distance) = inf;
         min_dis_this_set(i) = min(distance);
      end;

      % Take the average of the smallest distance of the n points and store it in vector min_dis_each_set
      min_dis_each_set(j) = mean(min_dis_this_set);
   end;

   % Take the average of the min distance of the m sets and store it in matrix min_dis_dim
   min_dis_dim(k, 2) = mean(min_dis_each_set);
end;

plot(min_dis_dim(:,1), min_dis_dim(:,2));
hold on;

end;

legend('N = 50', 'N = 100', 'N = 500');
xlabel('dimension');
ylabel('min distance');

savefig(figure1);
hold off;