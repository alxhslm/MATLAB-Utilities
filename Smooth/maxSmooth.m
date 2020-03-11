function [z,dz_dx,dz_dy] = maxSmooth(x,y,tol)
if nargout > 1
    [a,da] = absSmooth(x-y,tol);
else
    a = absSmooth(x-y,tol);
end

z = 0.5*(x+y+a);
if nargout > 1
    dz_dx = 0.5 + 0.5*da;
    dz_dy = 0.5 - 0.5*da;
end