function dw = deltaw(nhid,x,z,del),


nex = size(x,1);
o1 = ones(nex,1);
lx = [x o1];
dw = [];
j = 1;
k = 1;
for i=1:length(nhid)
	%ndw = del(j:j+nhid(i)-1)*lx';
	dd = del(:,j:j+nhid(i)-1);
	ndw = repmat(dd,[1 1 size(lx,2)]).*...
		repmat(permute(lx,[1 3 2]),[1 size(dd,2) 1]);
	dw = [dw reshape(ndw,[nex size(ndw,2) * size(ndw,3)])];
	lx = [z(:,j:j+nhid(i)-1) o1];
	j = j+nhid(i);
end;
dw = [dw repmat(del(:,end),[1 size(lx,2)]).*lx];
dw = -sum(dw',2);
