% Name: Yi Wu
% SID: 861028074
% Date: 11/19/2014
% Course: CS 229
% Assignment number: PS6

function KM2 = km_poly(X1,X2,d)
% KM2 = km_poly(X1,X2,d)
% X1, X2 are n*2 and m*2 matrices. KM2 returns the 2d polynomial k matrix which is n*m

    KM2 = (X1 * X2' + 1).^d;
end