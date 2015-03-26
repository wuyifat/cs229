% Name: Yi Wu
% SID: 861028074
% Date: 11/19/2014
% Course: CS 229
% Assignment number: PS6

function KM1 = km_radial(X1,X2,sigma)
% KM1 = km_radial(X1,X2,sigma)
% X1, X2 are n*2 and m*2 matrices. KM1 returns the radial k matrix which is n*m

KM1 = exp(-(repmat(sum(X1.^2, 2), 1, length(X2)) + repmat(sum(X2.^2, 2)', length(X1), 1) - 2 * (X1 * X2')) ./ (2 * sigma * sigma));

end