function [f,z,a] = fprop(x,nhid,w)

a = [];
z = [];
f = 0;
j = 1;
ln = size(x,2);
nex = size(x,1);
lx = x';

for i=1:length(nhid)
	W = reshape(w(j:(j+nhid(i)*(ln+1)-1)),nhid(i),ln+1);
	j = j+nhid(i)*(ln+1);
	ca = W*[lx;ones(1,nex)];
	a = [a ca'];
	lx = 1./(1+exp(-ca));
	z = [z lx'];
	ln = nhid(i);
end;
f = w(j:end)'*[lx;ones(1,nex)];
f = 1./(1+exp(-f'));
