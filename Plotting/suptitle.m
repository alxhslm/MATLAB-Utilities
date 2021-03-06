function hTitle = suptitle(ax,str,varargin)
ax = flipud(ax);
fig = ax(1).Parent;

ax_units = ax(1).Units;
fig_units = fig.Units;

[ax.Units] = deal('pixels');
fig.Units = 'pixels';

%% Create dummy axes and create the title
U = get(fig,'UserData');
if ~isfield(U,'supAxis')
    supax = supaxis(ax);
    supax_units = ax_units;
else
    supax = U.supAxis;
    supax_units = supax.Units;
    supax.Units = 'pixels';
end

supax.Visible = 'on';

hTitle = title(supax,sprintf('%s\n',str));
if ~isempty(varargin)
    set(hTitle,varargin{:});
end
title_units = hTitle.Units;
hTitle.Units = 'pixels';
setsupaxissize(ax,supax)

%% adjust figure size to fit title
fig_pos = fig.Position;
ax_pos = supax.Position;
title_pos = hTitle.Extent;

dh = ax_pos(2)+title_pos(2)+title_pos(4)-fig_pos(4);
dw = max(title_pos(3),fig_pos(3))-fig_pos(3);

if dw > 0
    dw = dw + 20;
    fig_pos([1 3]) = fig_pos([1 3]) + dw*[-0.5 1];
end

if dh > 0
    dh = dh + 10;
    fig_pos([2 4]) = fig_pos([2 4]) + dh*[0 1];
end
fig.Position = fig_pos;

mvlr(ax,dw/2);
setsupaxissize(ax,supax)

%reset original units
[ax.Units] = deal(ax_units);
fig.Units = fig_units;
supax.Units = supax_units;

tit_pos = hTitle.Position;
hTitle.Visible = 'on';
supax.Visible = 'off';
drawnow

hTitle.Position = tit_pos;
hTitle.Units = title_units;

U.supAxis = supax;
set(fig,'UserData',U);

function mvlr(ax,len)
for i = 1:numel(ax)
    pos = get(ax(i),'Position');
    pos(1) = pos(1) + len;
    set(ax(i),'Position',pos);
end