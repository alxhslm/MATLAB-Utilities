function hYlabel = supylabel(ax,str,varargin)
ax = flipud(ax);
fig = ax(1).Parent;

ax_units = ax(1).Units;
fig_units = fig.Units;

[ax.Units] = deal('pixels');
fig.Units = 'pixels';

%% Create dummy axes and create the label
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

hYlabel = ylabel(supax,sprintf('%s\n',str));
if ~isempty(varargin)
    set(hYlabel,varargin{:});
end
label_units = hYlabel.Units;
hYlabel.Units = 'pixels';
setsupaxissize(ax,supax)

%% adjust figure size to fit label
fig_pos = fig.Position;
ax_pos = supax.Position;
label_pos = hYlabel.Extent;

dw = -(ax_pos(1)+label_pos(1));
dh = max(label_pos(4),fig_pos(4))-fig_pos(4);

if dw > 0
    dw = dw + 20;
    fig_pos([1 3]) = fig_pos([1 3]) + dw*[-0.5 1];
    mvlr(ax,dw);
end

if dh > 0
    dh = dh + 10;
    fig_pos([2 4]) = fig_pos([2 4]) + dh*[-0.5 1];
    mvud(ax,dh/2);
end
fig.Position = fig_pos;

setsupaxissize(ax,supax)

%reset original units
[ax.Units] = deal(ax_units);
fig.Units = fig_units;
supax.Units = supax_units;

label_pos = hYlabel.Position;
hYlabel.Visible = 'on';
supax.Visible = 'off';
drawnow

hYlabel.Position = label_pos;
hYlabel.Units = label_units;

U.supAxis = supax;
set(fig,'UserData',U);

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