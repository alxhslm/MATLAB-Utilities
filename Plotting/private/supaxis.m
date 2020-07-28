function axTemp = supaxis(ax)
fig = get(ax(1),'parent');

axTemp = axes(fig,'Units','pixels','Visible','off');
axTemp.FontSize = ax(1).FontSize;
axTemp.TickLabelInterpreter = ax(1).TickLabelInterpreter;

axTemp.XLabel.String = ax(1,1).XLabel.String;
axTemp.XLabel.Interpreter = ax(1,1).XLabel.Interpreter;

axTemp.YLabel.String = ax(1,1).YLabel.String;
axTemp.YLabel.Interpreter = ax(1,1).YLabel.Interpreter;

uistack(axTemp,'bottom')
hold on
setsupaxissize(ax,axTemp);