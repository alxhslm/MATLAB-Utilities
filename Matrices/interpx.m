function yi = interpx(x,y,xi)
y = permute(y,[3 1 2]);
yi = interp1(x,y,xi);
yi = ipermute(yi,[3 1 2]);