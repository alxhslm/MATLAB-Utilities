function y = sym_polyval(p,x)
A = sym_polymat(x,length(p));
y = A*p;