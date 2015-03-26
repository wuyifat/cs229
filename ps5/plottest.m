

[X,Y] = meshgrid(0:0.1:3,0:0.1:3);
Z = 1./(1+exp(-X)).*1./(1+exp(-Y));

[c,h] = contourf(X,Y,Z,[-Inf 0.4 0.5 0.6 Inf]);
ch = g.Children; % this is the line that changes
for i=1:length(ch)
    if (get(ch(i),'CData')<0.5)
        set(ch(i),'FaceColor',[0.8 0.6 0.6]);
    else
        set(ch(i),'FaceColor',[0.6 0.6 0.8]);
    end;
end;
