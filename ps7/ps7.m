% Name: Yi Wu
% SID: 861028074
% Date: 12/4/2014
% Course: CS 229
% Assignment number: PS7

load -ascii class2d.ascii
% take the first two columns and append a column of 1 in the head to be x
X = class2d(:,1:2);
% take the last column to be y
Y = class2d(:,3);
expnum = size(X,1);

figure;
h1 = plot(X(Y==1,1),X(Y==1,2),'bx');
hold on;
h2 = plot(X(Y==-1,1),X(Y==-1,2),'ro');
axis equal;
npts = 100;
v = axis;
[x,y] = meshgrid(v(1):(v(2)-v(1))/npts:v(2),v(3):(v(4)-v(3))/npts:v(4));
[nx,ny] = size(x);


% --------------------part a----------------------------
plotid = 0;
bag_low = 0;
Z = zeros(nx,ny);
tree = cell(100,1,3);
%for bag = 10
for bag = [10,20,50,100]
    plotid = plotid + 1;
    Z = reshape(Z,nx*ny,1) * bag_low;    % use the old Z as the starting point
    
    for treeid = (bag_low+1):bag
        % use bootstrap to generate new training data
        expid = randi(expnum, [expnum,1]);
        Xa = X(expid,:);
        Ya = Y(expid,:);
        % train the tree on the new data set
        thistree = traindt(Xa,Ya,3,@splitentropy,5);
        tree(treeid,:,:) = thistree;
        Z = Z + dt([reshape(x,nx*ny,1) reshape(y,nx*ny,1)],tree(treeid,:,:));
    end;
    
    Z = Z / bag;
    Z = reshape(Z,nx,ny);
    bag_low = bag;
    subplot(2,2,plotid);
    hold on;
    
    map = [ 1.000 0.625 0.625 ;
            0.875 0.625 0.750 ;
            0.750 0.625 0.875 ;
            0.625 0.625 1.000 ;
           ];
    colormap(map);
 %   [c,h] = contourf(x,y,Z,[-Inf -1.0 0 1.0 Inf]);
    [c,h] = contourf(x,y,Z,[-Inf 0 Inf]);


    ch = get(h,'Children');  % this statement doesn't work on Matlab2014
                % if someone can find one that does, please let me know!
    for i=1:length(ch)
        v = get(ch(i),'FaceVertexCData');
        if (v>=1)
            set(ch(i),'FaceColor',[0.625 0.625 1.0]);
        elseif (v>=0)
            set(ch(i),'FaceColor',[0.75 0.625 0.875]);
        elseif (v<-1)
            set(ch(i),'FaceColor',[1.0 0.625 0.625]);
        else
            set(ch(i),'FaceColor',[0.875 0.625 0.75]);
        end;
        set(ch(i),'LineWidth',0.5);
    end;
%    [cc,hh] = contour(x,y,Z,[0 0],'LineColor',[0 0 0],'LineWidth',3.0);
    h1 = plot(X(Y==1,1),X(Y==1,2),'bx');
    hold on;
    h2 = plot(X(Y==-1,1),X(Y==-1,2),'ro');
    title(['part a, bag = ', num2str(bag)]);
end;

% ------------------------- part b------------------------

figure;
Xb = zeros(80,100);
xb = reshape(x,nx*ny,1);
yb = reshape(y,nx*ny,1);
plotid = 0;
for lambda = [0,2,5,10]
    plotid = plotid + 1;
    % calculate the features with 100 trees on each data point
    for i = 1:100
        Xb(:,i) = dt(X, tree(i,:,:));
    end;
    w = trainlogregL1(Xb,Y,lambda);
    nonzero_count = nnz(w(1:end-1));
  %  Z = w(end) .* ones(nx*ny,1);
    % calculate the tree matrix.
    tm = zeros(nx*ny,100);
    for i = 1:100
        tm(:,i) = dt([xb yb], tree(i,:,:));
    end;
    tm = [ones(nx*ny,1) tm];
    Z = tm * w;
    Z = reshape(Z,nx,ny);
    subplot(2,2,plotid);
    hold on;
    
    map = [ 1.000 0.625 0.625 ;
            0.875 0.625 0.750 ;
            0.750 0.625 0.875 ;
            0.625 0.625 1.000 ;
           ];
    colormap(map);
    [c,h] = contourf(x,y,Z,[-Inf 0 Inf]);

    ch = get(h,'Children');  % this statement doesn't work on Matlab2014
                % if someone can find one that does, please let me know!
    for i=1:length(ch)
        v = get(ch(i),'FaceVertexCData');
        if (v>=1)
            set(ch(i),'FaceColor',[0.625 0.625 1.0]);
        elseif (v>=0)
            set(ch(i),'FaceColor',[0.75 0.625 0.875]);
        elseif (v<-1)
            set(ch(i),'FaceColor',[1.0 0.625 0.625]);
        else
            set(ch(i),'FaceColor',[0.875 0.625 0.75]);
        end;
        set(ch(i),'LineWidth',0.5);
    end;
    h1 = plot(X(Y==1,1),X(Y==1,2),'bx');
    hold on;
    h2 = plot(X(Y==-1,1),X(Y==-1,2),'ro');    hold on;
    title(['part b, \lambda = ',num2str(lambda),', # of tree used = ', num2str(nonzero_count)]);
end;


% ------------------------- part c------------------------
figure;
plotid = 0;
boost_low = 0;
Z = zeros(nx,ny);
tree = cell(100,1,3);
alpha = ones(expnum,1);
w = zeros(0,0);
%for bag = 10
for boost = [10,20,50,100]
    plotid = plotid + 1;
    err_alpha = 0;
    w = [w;zeros(boost - boost_low,1)];
    
    for m = (boost_low+1):boost
        
        % train the tree on the new data set
        thistree = traindtw(X,Y,alpha,3,@splitentropy,5);
        tree(m,:,:) = thistree;
        % Adaboost
        fx = dt(X,thistree);
        diff = abs(fx-Y) ./ 2;
        nom = alpha' * diff;
        err = nom / sum(alpha);
        w(m) = log((1-err)/err);
        alpha = alpha .* exp(w(m)*diff);
    end;
    
    
    xc = reshape(x,nx*ny,1);
    yc = reshape(y,nx*ny,1);
    % calculate the features with boost trees on each data point
    for i = 1:boost
        Xb(:,i) = dt(X, tree(i,:,:));
    end;
    % calculate the tree matrix.
    tm = zeros(nx*ny,boost);
    for i = 1:boost
        tm(:,i) = dt([xc yc], tree(i,:,:));
    end;
    Z = tm * w;
    
    Z = reshape(Z,nx,ny);
    boost_low = boost;
    subplot(2,2,plotid);
    hold on;
    
    map = [ 1.000 0.625 0.625 ;
            0.875 0.625 0.750 ;
            0.750 0.625 0.875 ;
            0.625 0.625 1.000 ;
           ];
    colormap(map);
    %[c,h] = contourf(x,y,Z,[-Inf -1.0 0 1.0 Inf]);
  
    [c,h] = contourf(x,y,Z,[-Inf 0 Inf]);

    ch = get(h,'Children');  % this statement doesn't work on Matlab2014
                % if someone can find one that does, please let me know!
    for i=1:length(ch)
        v = get(ch(i),'FaceVertexCData');
        if (v>=1)
            set(ch(i),'FaceColor',[0.625 0.625 1.0]);
        elseif (v>=0)
            set(ch(i),'FaceColor',[0.75 0.625 0.875]);
        elseif (v<-1)
            set(ch(i),'FaceColor',[1.0 0.625 0.625]);
        else
            set(ch(i),'FaceColor',[0.875 0.625 0.75]);
        end;
        set(ch(i),'LineWidth',0.5);
    end;
    h1 = plot(X(Y==1,1),X(Y==1,2),'bx');
    hold on;
    h2 = plot(X(Y==-1,1),X(Y==-1,2),'ro');
    title(['part c, boost = ', num2str(boost)]);
end;


% --------------------- part d-----------------------------

figure;
load -ascii spamtrain.ascii
load -ascii spamtest.ascii
X = spamtrain(:,1:end-1);
Y = spamtrain(:,end);
x = spamtest(:,1:end-1);
y = spamtest(:,end);
train_num = size(X,1);
test_num = size(x,1);

% -------------- d.a----------------
bag_low = 0;
tree = cell(200,1);
Z = zeros(size(x,1),1);
id = 0;
err1 = zeros(size(20:20:200));

for bag = 20:20:200
    
    id = id + 1;

    for treeid = (bag_low+1):bag
        % use bootstrap to generate new training data
        expid = randi(train_num, [train_num,1]);
        Xa = X(expid,:);
        Ya = Y(expid,:);
        % train the tree on the new data set
        thistree = traindt(Xa,Ya,6,@splitentropy,100);
        tree{treeid} = thistree;
        % test
        Z = Z + dt(x,tree{treeid});
    end;
    
    err1(id) = sum(sign(Z/bag) ~= y) / test_num;
    bag_low = bag;
end;
plot(20:20:200,err1);
hold on;

% -------------d.b---------------
Xb = zeros(train_num,200)
err2 = zeros(11,1);
id = 0;
x2 = [];
for lambda = 0:0.5:5
    id = id + 1;
    % calculate the features with 200 trees on each data point
    for i = 1:200
        Xb(:,i) = dt(X, tree{i});
    end;
    w = trainlogregL1(Xb,Y,lambda);
    nonzero_count = nnz(w(1:end-1));
    x2 = [x2; nonzero_count];
    
    % calculate the tree matrix.
    tm = zeros(test_num,200);
    for i = 1:200
        tm(:,i) = dt(x, tree{i});
    end;
    tm = [ones(test_num,1) tm];
    Z = tm * w;
    err2(id) = sum(sign(Z)~=y)/test_num;
end;
plot(x2,err2);
hold on;

% -------------------d.c-------------------------
boost_low = 0;
tree = cell(200,1);
alpha = ones(train_num,1);
w = zeros(0,0);
err3 = zeros(size(20:20:200));
id = 0;
for boost = 20:20:200
    id = id + 1;
    err_alpha = 0;
    w = [w;zeros(boost - boost_low,1)];
    
    for m = (boost_low+1):boost
        
        % train the tree on the new data set
        thistree = traindtw(X,Y,alpha,6,@splitentropy,100);
        tree{m} = thistree;
        % Adaboost
        fx = dt(X,thistree);
        diff = abs(fx-Y) ./ 2;
        nom = alpha' * diff;
        err = nom / sum(alpha);
        w(m) = log((1-err)/err);
        alpha = alpha .* exp(w(m)*diff);
    end;
    
    % calculate the features with boost trees on each data point
    for i = 1:boost
        Xb(:,i) = dt(X, tree{i});
    end;
    % calculate the tree matrix.
    tm = zeros(test_num,boost);
    for i = 1:boost
        tm(:,i) = dt(x, tree{i});
    end;
    Z = tm * w;
    err3(id) = sum(sign(Z) ~= y) / test_num;
    boost_low = boost;
end;
plot(20:20:200,err3);
hold on;
title('part d');
xlabel('number of trees');
ylabel('error rate');
legend('bagging','refig bagging','boosting');
