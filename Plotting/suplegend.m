function hLeg = suplegend(ax,hLine,labels,loc,varargin)
ax = flipud(ax);
fig = get(ax(1),'parent');
set(ax(:),'units','pixels')

%% Create dummy axes and create the legend
axTemp = axes(fig,'Units','pixels');
hold on
for i = 1:length(hLine)
    hTemp(i) = copyobj(hLine(i),axTemp);
end
hLeg = legend(axTemp,hTemp,labels,'Location',[loc 'Outside'],varargin{:});
drawnow

%% adjust figure size to fit legend
set(hLeg,'Units','pixels')
leg_pos = get(hLeg,'Position');

set(fig(:),'units','pixels')
fig_pos = get(fig,'position');

switch loc
    case  {'East' 'West'}
        dw = leg_pos(3)+20;
        dh = max(leg_pos(4)+20,fig_pos(4))-fig_pos(4);
    case {'North','South'}
        dh = leg_pos(4)+20;
        dw = max(leg_pos(3)+20,fig_pos(3))-fig_pos(3);
end


fig_pos([1 3]) = fig_pos([1 3]) + dw*[-0.5 1];
fig_pos([2 4]) = fig_pos([2 4]) + dh*[-0.5 1];
set(fig,'Position',fig_pos);

mvlr(ax,dw/2);
mvud(ax,dh/2);

posBL = get(ax(1,1),'Position');
posTR = get(ax(end,end),'Position');
posAx = [posBL(1:2) posTR(1:2)+posTR(3:4)-posBL(1:2)];
set(axTemp,'Position',posAx)

set(ax(:),'units','Normalized')
set(axTemp(:),'units','Normalized')
set(hLeg,'Units','Normalized')

%centre legend
leg_pos = get(hLeg,'Position');
posAx = get(axTemp,'Position');
switch loc
    case  {'East' 'West'}
        leg_pos(2) = posAx(2) + (posAx(4) - leg_pos(4))/2;
    case {'North','South'}
        leg_pos(1) = posAx(1) + (posAx(3) - leg_pos(3))/2;
end

%% Create new legend linked to the actual axis
delete(axTemp);
axLeg = get(hLine(1),'Parent');
hLeg = legend(axLeg,hLine,labels,'Units','Normalized','Position',leg_pos,varargin{:});
drawnow

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