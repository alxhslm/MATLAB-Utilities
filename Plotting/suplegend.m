function hLeg = suplegend(ax,hLine,labels,loc,varargin)
ax = flipud(ax);
fig = ax(1).Parent;

ax_units = ax(1).Units;
fig_units = fig.Units;

[ax.Units] = deal('pixels');
fig.Units = 'pixels';

%% Create dummy axes and create the legend
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

drawnow
hLeg = legend(supax,hLine,labels,'Location',[loc 'Outside']);
if ~isempty(varargin)
    props = varargin(1:2:end);
    iTitle = find(strcmpi(props,'title'));
    if ~isempty(iTitle)
        leg_title = varargin(2*iTitle);
        varargin(2*(iTitle-1) + (1:2)) = []; 
    else
        leg_title = '';
    end
    set(hLeg,varargin{:});
    hLeg.Title.String = leg_title;
end
leg_units = hLeg.Units;
hLeg.Units = 'pixels';
setsupaxissize(ax,supax);

%% adjust figure size to fit legend
fig_pos = fig.Position;
leg_pos = hLeg.Position;

switch loc
    case  'East'
        dw = leg_pos(1)+leg_pos(3)-fig_pos(3);
        dh = max([leg_pos(4),fig_pos(4)])-fig_pos(4);
    case  'West'
        dw = -leg_pos(1);
        dh = max([leg_pos(4),fig_pos(4)])-fig_pos(4);
    case 'South'
        dh = -leg_pos(2);
        dw = max([leg_pos(3),fig_pos(3)])-fig_pos(3);
    case 'North'
        dh = leg_pos(2)+leg_pos(4)-fig_pos(4);
        dw = max([leg_pos(3),fig_pos(3)])-fig_pos(3);
end

if dw > 0
    dw = dw + 10;
    fig_pos([1 3]) = fig_pos([1 3]) + dw*[-0.5 1];
end
if dh > 0
    dh = dh + 10;
    fig_pos([2 4]) = fig_pos([2 4]) + dh*[-0.5 1];
end
fig.Position = fig_pos;

switch loc
    case  'East'
        mvud(ax,dh/2);
    case  'West'
        mvud(ax,dh/2);
        mvlr(ax,dw);
    case 'South'
        mvlr(ax,dw/2);
        mvud(ax,dh);
    case 'North'
        mvlr(ax,dw/2);
end
setsupaxissize(ax,supax)

%reset original units
[ax.Units] = deal(ax_units);
fig.Units = fig_units;
supax.Units = supax_units;

leg_pos = hLeg.Position;
hLeg.Visible = 'on';
supax.Visible = 'off';
drawnow

hLeg.Position = leg_pos;
hLeg.Units = leg_units;

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