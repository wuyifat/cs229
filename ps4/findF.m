% Name: Yi Wu
% SID: 861028074
% Date: 11/07/2014
% Course: CS 229
% Assignment number: PS4

function zf = findF(x, y, w1, w2, wf)
    if size(w2) > 1,
        more = true;
    else
        more = false;
    end;
    
    n = size(x,1);
    m = size(x,2);
    bias = ones(n * m, 1);
    z0 = [bias, x(:), y(:)];
    a1 = z0 * w1';
    z1 = [bias, g(a1)];
    if more,
        a2 = z1 * w2';
        z2 = [bias, g(a2)];
        af = z2 * wf';
    else
        af = z1 * wf';
    end;
    zf = g(af);
    zf = reshape(zf, [n,m]);
end