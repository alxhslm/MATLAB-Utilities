function b = innullspace(AConstr,A)
err = abs(AConstr * A);
b = max(abs(err))<1E-10;