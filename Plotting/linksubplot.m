function linksubplot(ax,dir)
if nargin < 2
    dir = 'xmp';
end
if any(dir == 'x')
    link.x = linkprop(ax(:),{'xlim'});
end
if any(dir == 'm')
    link.mag = linkprop(ax(1,:),'ylim');
end
if any(dir == 'p')
    link.phase = linkprop(ax(2,:),'ylim');
end
fig = get(ax(1),'Parent');
setappdata(fig,'links',link)