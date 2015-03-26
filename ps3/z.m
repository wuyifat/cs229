% Name: Yi Wu
% SID: 861028074
% Date: 10/28/2014
% Course: CS 229
% Assignment number: PS3

function z_value = z(x,w,y,R)
% calculate the z value

step = 0.001;
p = sigma(x,w,y);
z_value = x * w + y ./ p;
