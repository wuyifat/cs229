function [alpha,b] = solvesvm(K,Y,C)
% function [alpha,b] = solvesvm(K,Y,C)
% Solves the support vector machine quadratic
% program:  min 0.5 * alpha' * K * alpha - C * ones' * Y
% subject to 0 <= alpha <= C   and    ones' * alpha = 1
% where C may be a vector (to give different points different weights)
% returns the proper bias (b) for the primal problem
% resulting classifier is f(x) = b + sum_i alpha_i * K(x,x_i)
% (that is, y_i has already been multiplied into alpha_i)
% Note that many of the alpha values may be zero.
%
% uses monqp ("my qp") from
% http://asi.insa-rouen.fr/enseignants/~arakotom/toolbox/index.html

K = K+eye(size(K,1))*0.0001; %*max(max(K))*1e-5;
[w,b,p] = monqp(K.*(Y*Y'),ones(size(Y,1),1),Y,0,C);
w = w.*Y(p);
alpha = zeros(size(Y,1),1);
alpha(p) = w;
