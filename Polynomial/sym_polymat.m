function A = sym_polymat(x,n)
A = [];
for i = n:-1:1
    if i > 0
        A(:,end+1) = abs(x).^i .* sign(x);
    else
        A(:,end+1) = 1;
    end
end