function [y,dy] = absSmooth(x,tol)
y = sqrt(x.^2 + tol);
if nargout > 1
    dy = x./y;
end