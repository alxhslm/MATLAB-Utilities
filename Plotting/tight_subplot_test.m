Nw = 2;
Nh = 4;
figure
for i = 1:Nh
    for j = 1:Nw
        ax(i,j) = subplot(Nh,Nw,j + (i-1)*Nw);
    end
end
drawnow

gap(2) = ax(1,2).Position(1) - sum(ax(1,1).Position([1 3]));
marg_w = [ax(1,1).Position(1) 1-sum(ax(1,Nw).Position([1 3]))];

gap(1) = ax(Nh-1).Position(2) - sum(ax(Nh,1).Position([2 4]));
marg_h = [ax(Nh,1).Position(2)  1-sum(ax(1,1).Position([2 4]))];

for i = 1:Nh
    for j = 1:Nw
    ha = tight_subplot(Nh, Nw, j + (i-1)*Nw, gap, marg_h, marg_w);
    end
end