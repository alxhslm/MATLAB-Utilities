function V = structarray2struct(S,fields)
if nargin < 2
    fields = fieldnames(S);
end
for i = 1:length(fields)
     V.(fields{i}) = cat(1,S(:).(fields{i}));
end