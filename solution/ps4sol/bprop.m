function [del] = bprop(nhid,w,z,f,y)

j = length(w);
ld = (f-y)';
ln = 1;
del = ld';
k = size(z,2);
for i=length(nhid):-1:1
	W = reshape(w(j-(nhid(i)+1)*ln+1:j),ln,nhid(i)+1);
	j = j-(nhid(i)+1)*ln;
	cz = z(:,k-nhid(i)+1:k)';
	k = k-nhid(i);
	nd = W'*ld;
	nd = nd(1:end-1,:);
	nd = nd.*cz.*(1-cz);
	del = [nd' del];
	ln = nhid(i);
	ld = nd;
end;
