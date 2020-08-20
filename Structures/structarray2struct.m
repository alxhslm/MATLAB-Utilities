function V = structarray2struct(S,fields)
if nargin < 2
    fields = fieldnames(S);
end
for i = 1:length(fields)
    if ischar(S(1).(fields{i}))
        V.(fields{i}) = {S(:).(fields{i})}';
    else
        V.(fields{i}) = cat(1,S(:).(fields{i}));
    end
end