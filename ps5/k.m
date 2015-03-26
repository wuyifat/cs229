% Name: Yi Wu
% SID: 861028074
% Date: 11/13/2014
% Course: CS 229
% Assignment number: PS5

function kVal = k(x1,x2,y1,y2,sigma)
% calculate the k value given point x and point y
    dist = ((x1 - y1)^2 + (x2 - y2)^2);
    kVal = exp(-dist / (2 * sigma * sigma));

end
