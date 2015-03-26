function dw = nngrad(nhid,w,x,y)

[f,z,a] = fprop(x,nhid,w);
del = bprop(nhid,w,z,f,y);
dw = deltaw(nhid,x,z,del);
