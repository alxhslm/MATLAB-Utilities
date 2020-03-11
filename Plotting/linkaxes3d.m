function linkaxes3d(ax)
Link = linkprop(ax,{'CameraUpVector', 'CameraPosition', 'CameraTarget'});
fig = get(ax(1),'Parent');
setappdata(fig, 'StoreTheLink', Link);
