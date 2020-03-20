function ax_pol = subpolarplot(varargin)
ax_cart = subplot(varargin{:});
ax_pol = polaraxes('Position',get(ax_cart,'Position'));
delete(ax_cart);