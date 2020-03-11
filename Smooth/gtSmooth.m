function r = gtSmooth(x,y,tol)
if tol > 0
    r = 0.5*(1+sgnSmooth(x-y,tol));
else
    r = x > y;
end