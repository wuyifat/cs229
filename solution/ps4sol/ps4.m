load -ascii class2d.ascii

trainX = class2d(:,1:2);
trainY = class2d(:,3);
fnum = 1;
nhlayers = 1;
nhidpers = 5;
lambdas = 0.1;
for nlayer = nhlayers
	for nhidper = nhidpers
		for l = lambdas
			h = ones(1,nlayer)*nhidper;
%            figure(fnum);
			w = trainnn(h,trainX,trainY,l);
			plotall(trainX,trainY,@fprop,50,h,w);
			title(['hidden = ' sprintf('%d ',h) sprintf('lambda=%g',l)]);
			% code to print here... depends on how you import graphics
			fnum = fnum+1;
		end;
	end;
end;
