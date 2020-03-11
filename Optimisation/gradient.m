function G = gradient(fun,x,varargin)
g0 = feval(fun,x,varargin{:});
G = x(:)'*0;
h = 1E-8 + 0*x;
dx = diag(h);
for i = 1:length(x)
    g = feval(fun,x + dx(:,i),varargin{:});
    G(i) = (g - g0)/h(i);
end

