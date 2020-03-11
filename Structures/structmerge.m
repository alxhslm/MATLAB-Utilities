function A = structmerge(A,B,bOverwrite,bRecursive)
if nargin < 4
    bRecursive = 0;
    if nargin < 3
        bOverwrite = 1;
    end
end

fa = fieldnames(A);
fb = fieldnames(B);

for i = 1:length(fb)
    if ~any(strcmp(fa,fb{i}))
        A.(fb{i}) = B.(fb{i});
    elseif bOverwrite
        if isstruct(B.(fb{i})) && isstruct(A.(fb{i}))
            A.(fb{i}) = structmerge(A.(fb{i}), B.(fb{i}), bOverwrite, bRecursive);
        else
            A.(fb{i}) = B.(fb{i});
        end
    end
end