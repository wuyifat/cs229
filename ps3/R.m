% Name: Yi Wu
% SID: 861028074
% Date: 10/28/2014
% Course: CS 229
% Assignment number: PS3

function R_matrix = R(x,w,y)
% calculate the R value

n = size(x,1);
p = sigma(x,w,y);
p = p .* (1 - p);
p = repmat(p, [1, n]);
I = eye(n);
R_matrix = p .* I;
