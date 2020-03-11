function y = range(x,dim)
if nargin < 2
    if isvector(x)
        sz = size(x);
        [~,dim] = max(sz);
    else
        dim = 1;
    end
end
y = max(x,[],dim) - min(x,[],dim);