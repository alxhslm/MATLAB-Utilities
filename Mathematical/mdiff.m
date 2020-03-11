function [d,xd] = mdiff(x,y,order)
%ADIFF computes the derivative of the 
d = diff(y)./repmat(diff(x),1,size(y,2));
xd = x(1:end-1) + 0.5*diff(x);

if nargin < 3
    order = 1;
end

if order > 1
    d = mdiff(xd,d,order-1);
end

d = interp1(xd,d,x,'linear','extrap');