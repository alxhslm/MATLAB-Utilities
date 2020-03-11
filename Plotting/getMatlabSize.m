function pos = getMatlabSize
desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
mainWindow = desktop.getMainFrame;
pos = getPos(mainWindow);

% pos(1) = pos(1)-50;
% setPos(mainWindow,pos);

function pos = getPos(container)
loc = container.getLocation();
siz = container.getSize();
pos = [loc.getX loc.getY siz.getWidth siz.getHeight];

function setPos(container,pos)
container.setLocation(pos(1),pos(2));
container.setSize(pos(3),pos(4));

