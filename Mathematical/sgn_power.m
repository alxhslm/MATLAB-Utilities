function [y,dy_dx] = sgn_power(x,n)
y = sign(x).*(abs(x).^n);
if nargout > 1
    dy_dx = (abs(x).^(n-1)).*n;
end