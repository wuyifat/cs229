% Name: Yi Wu
% SID: 861028074
% Date: 10/28/2014
% Course: CS 229
% Assignment number: PS3

function sig = sigma(x,w,y)
% calculates the sigma function on given x,w matrix and value y

a = y .* (x * w);
sig = 1 ./ (1 + exp(-a));