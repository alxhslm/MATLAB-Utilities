function [hLeg,axTemp] = suplegend(ax,hLine,labels,loc,varargin)
ax = flipud(ax);
fig = get(ax(1),'parent');
ax_units = ax(1).Units;
set(ax(:),'units','pixels')

%% Create dummy axes and create the legend
axTemp = axes(fig,'Units','pixels','Visible','off');
uistack(axTemp,'bottom')
hold on

hLeg = legend(axTemp,hLine,labels,'Location',[loc 'Outside'],varargin{:});
leg_units = hLeg.Units;
hTitle = title(axTemp,'temp');
drawnow

%% adjust figure size to fit legend
set(hLeg,'Units','pixels')
leg_pos = get(hLeg,'Position');

set(hTitle,'Units','pixels')
tit_pos = get(hTitle,'Extent');

set(fig(:),'units','pixels')
fig_pos = get(fig,'position');

switch loc
    case  {'East' 'West'}
        dw = leg_pos(3)+tit_pos(3);
        dh = max([leg_pos(4),fig_pos(4),tit_pos(4)])-fig_pos(4);
    case {'North','South'}
        dh = leg_pos(4)+tit_pos(4);
        dw = max([leg_pos(3),fig_pos(3),tit_pos(3)])-fig_pos(3);
end

fig_pos([1 3]) = fig_pos([1 3]) + dw*[-0.5 1];
fig_pos([2 4]) = fig_pos([2 4]) + dh*[-0.5 1];
set(fig,'Position',fig_pos);

if strcmp(loc,'West')
    mvlr(ax,leg_pos(3));
end
if strcmp(loc,'South')
    mvud(ax,leg_pos(4));
end

delete(hTitle);

posBL = get(ax(1,1),'Position');
posTR = get(ax(end,end),'Position');
posAx = [posBL(1:2) posTR(1:2)+posTR(3:4)-posBL(1:2)];
set(axTemp,'Position',posAx)

%centre legend
leg_pos = get(hLeg,'Position');
posAx = get(axTemp,'Position');
switch loc
    case  {'East' 'West'}
        leg_pos(2) = posAx(2) + (posAx(4) - leg_pos(4))/2;
    case {'North','South'}
        leg_pos(1) = posAx(1) + (posAx(3) - leg_pos(3))/2;
end
set(hLeg,'Position',leg_pos)

%reset original units
set(ax(:),'units',ax_units)
set(axTemp(:),'units',ax_units)
set(hLeg,'Units',leg_units)

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