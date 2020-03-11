function J = jacobian(fun,x,varargin)
f0 = feval(fun,x,varargin{:});
h = 1E-10+0*abs(x(:));

J = f0 *x(:)'*0;
x0 = x;
for i = 1:length(x)
    x = x0;
    x(i,:) = x(i,:) + h(i);
    f = feval(fun,x,varargin{:});
    J(:,i) = (f - f0)./h(i);
end