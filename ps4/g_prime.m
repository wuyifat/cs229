% Name: Yi Wu
% SID: 861028074
% Date: 11/07/2014
% Course: CS 229
% Assignment number: PS4

function sig = g_prime(a)
% calculates the sigma function on given x,w matrix and value y

sig = exp(-a) ./ (1 + exp(-a)).^2;