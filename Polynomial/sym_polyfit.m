function p = sym_polyfit(x,y,n)
A = sym_polymat(x,n);
p = A\y;