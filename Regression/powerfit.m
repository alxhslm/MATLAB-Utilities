function p = powerfit(X,Y)
sgn = sign(mean(Y));
X = log(X + eps);
Y = log(max(Y*sgn,0) + eps);
p = polyfit(X,Y,1);
p(2) = sgn*exp(p(2));