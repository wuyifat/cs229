function split = splitentropy(X,Y,alpha,isleaf,minnum)

cl = unique(Y);
Ys = repmat(Y,1,length(cl))==repmat(cl',size(Y,1),1);
Ys = Ys.*repmat(alpha,1,length(cl));
[~,split] = max(sum(Ys,1),[],2);
split = cl(split);
if (~isleaf && size(X,1)>minnum && length(cl)>1)
	bestent = inf;
	bestvar = 0;
	bestth = 0;
	for d=1:size(X,2)
		[ent,th] = splitentd(d,X,Y,alpha,cl);
		if (ent<bestent)
			bestent = ent;
			bestvar = d;
			bestth = th;
		end;
	end;
	if (~isinf(bestent))
		split = [bestvar,bestth];
	end;
end;

function [ent,th] = splitentd(d,X,Y,alpha,cl)


[Xp,perm] = sort(X(:,d),1);
Yp = Y(perm);
ap = alpha(perm);

csum = repmat(Yp,1,length(cl))==repmat(cl',size(Yp,1),1);
csum = csum.*repmat(ap,1,length(cl));
csum = cumsum(csum,1);
sm = sum(csum,2);
sm = repmat((1:size(Yp,1))',1,size(csum,2));

entl = zeros(size(csum));
entr = entl;

p= csum./sm;
entl(csum>0) = -csum(csum>0).*log(p(csum>0));

csum = repmat(csum(end,:),size(csum,1),1) - csum;
sm = sm(end)-sm;
p = csum./sm;
entr(csum>0) = -csum(csum>0).*log(p(csum>0));

entl = sum(entl,2)+sum(entr,2);
eq = [Xp(1:end-1)==Xp(2:end); false];
entl(eq) = inf;
[ent,i] = min(entl);
if (ent==entl(end))
	ent = inf;
	th = 0;
else
	th = (Xp(i)+Xp(i+1))/2;
end;
