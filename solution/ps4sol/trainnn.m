function w = trainnn(nhid,X,Y,lambda)

N = size(X,1);
d = size(X,2);

nw = sum([d+1 nhid+1].*[nhid 1]);
w = rand(nw,1)*2-1;

i = 1;
eta = 1;
olderr = 0;
err = inf;
while(isinf(err) || (abs(olderr-err)/eta > 1e-4 && max(abs(dw)) > 1e-4))
	olderr = err;
	err = nnerr(X,Y,nhid,w,lambda);
	eta = 5000/(2500+i)/N;
	dw = nngrad(nhid,w,X,Y) - lambda*w;
	w = w + eta*dw;
	i = i+1;
	if (mod(i,1000)==0)
		plotall(X,Y,@fprop,50,nhid,w);
		pause(0.001);
		i
		w'
		err
	end;
end;
