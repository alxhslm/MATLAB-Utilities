function linksubplot3d(ax)
link.xy = linkprop(ax(:),{'xlim','ylim'});
link.mag = linkprop(ax(1,:),'clim');
link.phase = linkprop(ax(2,:),'clim');
fig = get(ax(1),'Parent');
setappdata(fig,'links',link)
