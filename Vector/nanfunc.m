function M = nanfunc(fun,X,dim)
if nargin < 3
    if isvector(X)
        dim = find(size(X)>1);
    else
        dim = 1;
    end
end

ii = 1:ndims(X);
ii = [dim, ii(ii~=dim)];
Y = permute(X,ii);
M = zeros(1,size(Y,2),size(Y,3));
for i = 1:size(Y,2)
    for j = 1:size(Y,3)
        Z = Y(:,i,j);
        iNotNan = ~isnan(Z);
        if any(iNotNan)
            M(1,i,j) = feval(fun,Z(iNotNan));
        else
            M(1,i,j) = NaN;
        end
    end
end
M = ipermute(M,ii);