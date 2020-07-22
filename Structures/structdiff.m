function a = structdiff(A,B)
a = {};

if iscell(A) && iscell(B)
    Na = length(A);
    Nb = length(B);
    N = max(Na,Nb);
    for k = 1:N
        if (k > Na) || (k > Nb)
            a{end+1} = sprintf('{%d}',k);
        else
            if isstruct(B{k}) && isstruct(A{k})
                tmp = structdiff(A{k}, B{k});
                a = [a strcat(sprintf('{%d}',k), tmp)];
            elseif iscell(B{k}) && iscell(A{k})
                tmp = structdiff(A{k}, B{k});
                a = [a strcat(sprintf('{%d}',k), tmp)];
            elseif ~isequal(A{k}, B{k})
                a = [a sprintf('{%d}',k)];
            end
        end
    end
    return;
end

fa = fieldnames(A);
fb = fieldnames(B);
[com,ia,ib] = intersect(fa,fb);
tot = union(fa,fb);
Na = length(A);
Nb = length(B);
N = max(Na,Nb);

missing = [fa(~ia) fb(~ib)];

for j = 1:N
    if (j > Na) || (j > Nb)
        a{end + 1} = strcat(sprintf('(%d)',j), tot);
    else
        for i = 1:length(com)
            if isstruct(B(j).(com{i})) && isstruct(A(j).(com{i}))
                tmp = structdiff(A(j).(com{i}), B(j).(com{i}));
                if N > 1
                    a = [a strcat(sprintf('(%d).%s',j,com{i}) ,tmp)];
                else
                    a = [a strcat([ '.' com{i}],tmp)];
                end
            else
                if ~all(size(B(j).(com{i})) == size(A(j).(com{i})))
                    if N > 1
                        a{end+1} = sprintf('(%d).%s',j,com{i});
                    else
                        a{end+1} = ['.' com{i}];
                    end
                elseif iscell(B(j).(com{i})) && iscell(A(j).(com{i}))
                    tmp = structdiff(A(j).(com{i}), B(j).(com{i}));
                    if N > 1
                        a = [a strcat(sprintf('(%d).%s',j,com{i}) ,tmp)];
                    else
                        a = [a strcat([ '.' com{i}],tmp)];
                    end
                elseif isnumeric(B(j).(com{i})) && ~isequal_nan(A(j).(com{i}), B(j).(com{i}))
                    if N > 1
                        a{end+1} = sprintf('(%d).%s',j,com{i});
                    else
                        a{end+1} = ['.' com{i}];
                    end
                elseif ~isequal(A(j).(com{i}), B(j).(com{i}))
                    if N > 1
                        a{end+1} = sprintf('(%d).%s',j,com{i});
                    else
                        a{end+1} = ['.' com{i}];
                    end
                end
            end
        end
        if ~isempty(missing)
            if N > 1
                a = [a strcat(sprintf('(%d)',j), missing)];
            else
                a = [a missing];
            end
        end
    end
end