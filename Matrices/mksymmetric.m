function A = mksymmetric(A)
A = 0.5*(mtransposex(A) + A);