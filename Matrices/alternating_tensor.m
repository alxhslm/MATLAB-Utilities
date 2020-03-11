function M = alternating_tensor(i,j)
M = (2*(mod(i+j,2) == 0)-1);