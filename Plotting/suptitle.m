function hTitle = suptitle(ax,str,varargin)
ax = flipud(ax);
fig = get(ax(1),'parent');
set(ax(:),'units','pixels')

%% Create dummy axes and create the legend
axTemp = axes(fig,'Units','pixels');
hold on
hTitle = title(axTemp,str,varargin{:});
drawnow

%% adjust figure size to fit legend
set(hTitle,'Units','pixels')
title_pos = get(hTitle,'Extent');

set(fig(:),'units','pixels')
fig_pos = get(fig,'position');

dh = title_pos(4)+20;
dw = max(title_pos(3)+20,fig_pos(3))-fig_pos(3);

fig_pos([1 3]) = fig_pos([1 3]) + dw*[-0.5 1];
fig_pos([2 4]) = fig_pos([2 4]) + dh*[-0.5 1];
set(fig,'Position',fig_pos);

mvlr(ax,dw/2);
mvud(ax,dh/2);

posBL = get(ax(1,1),'Position');
posTR = get(ax(end,end),'Position');
posAx = [posBL(1:2) posTR(1:2)+posTR(3:4)-posBL(1:2)];
set(axTemp,'Position',posAx,'Visible','off')

set(ax(:),'units','Normalized')
set(axTemp(:),'units','Normalized')
set(hTitle,'Units','Normalized')

%centre legend
title_pos = get(hTitle,'Position');
title_bb = get(hTitle,'Extent');
title_pos(2) = title_pos(2) + title_bb(4);
set(hTitle,'Position',[title_pos(1:2) 0],'Visible','on')

function mvud(ax,len)
for i = 1:numel(ax)
    pos = get(ax(i),'Position');
    pos(2) = pos(2) + len;
    set(ax(i),'Position',pos);
end

function mvlr(ax,len)
for i = 1:numel(ax)
    pos = get(ax(i),'Position');
    pos(1) = pos(1) + len;
    set(ax(i),'Position',pos);
end