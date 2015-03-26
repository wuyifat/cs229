function w = trainlogregL1(X,Y,lambda)
% function w = trainlogregL1(X,Y,lambda)
%
% X is n x d
% Y is n x 1 (values +1 or -1)
% lambda is the L1-regularization coefficient
% w is (d+1) x 1
%
% solves min_(w,w0) sum (log(1+e^(-y_i*(w'*x_i + w0)))) + lambda*sum(abs(w_i))
% returns [w;w0] (w0 is the "bias" or "intercept" term)

% despite what the comments in logreg say, X needs to be multiplied by Y
% already (see example on Boyd's webpage that accompanies the code)
[z,his] = logreg(X.*repmat(Y,1,size(X,2)),Y,lambda/size(X,1),1.0,1.0);

w = [z(2:end); z(1)];
