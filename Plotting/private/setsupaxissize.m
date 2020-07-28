function setsupaxissize(ax,axTemp)
posBL = ax(1,1).Position;
posTR = ax(end,end).Position;
posAx = [posBL(1:2) posTR(1:2)+posTR(3:4)-posBL(1:2)];
axTemp.Position = posAx;