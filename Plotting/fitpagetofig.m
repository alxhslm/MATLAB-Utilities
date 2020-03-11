function fitpagetofig(fig)
oldunits = get(fig,'Units');
set(fig, 'PaperUnits', 'centimeters', 'Units', 'centimeters');
figpos = get(fig, 'Position');
set(fig, 'PaperSize', figpos(3:4),'PaperPosition',[0 0 figpos(3:4)], 'Units', oldunits);