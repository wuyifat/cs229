function rate = nnerr(X,Y,nhid,w,lambda)
	f = fprop(X,nhid,w);
	rate = -sum(log(f(Y==1)))-sum(log(1-f(Y==0)));
	rate = (rate + lambda*w'*w/2)/size(X,1);
