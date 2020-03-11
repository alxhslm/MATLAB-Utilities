function b = ismonotonic(x)
b = all(diff(x)>0);