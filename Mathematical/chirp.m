function [w,p,dw] = chirp(t,wStart,wEnd,tDur,tRunIn)
wGrad = (wEnd - wStart)/tDur;
dw = wGrad * (t > tRunIn);
w = wStart + dw.*(t-tRunIn);
p = wStart*(t-tRunIn) + 0.5*dw.*(t-tRunIn).^2;