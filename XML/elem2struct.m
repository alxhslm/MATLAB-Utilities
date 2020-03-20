function E = elem2struct(S,elem)
if ~iscell(S.(elem))
    S.(elem) = {S.(elem)};
end
for j = 1:length(S.(elem))
    fields = fieldnames(S.(elem){j});
    
    iAttrib = cellfun(@(x)strcmp(x,'Attributes'),fields);
    
    sub_elem = fields(~iAttrib);
    for k = 1:length(sub_elem)
        if isfield(S.(elem){j}.(sub_elem{k}),'Attributes') || ~isfield(S.(elem){j}.(sub_elem{k}),'Text')
            E.(sub_elem{k}) = elem2struct(S.(elem){j},sub_elem{k});
        else
            [number, bOK]= str2num(S.(elem){j}.(sub_elem{k}).Text);
            if bOK
                E.(sub_elem{k})(j,1) = number;
            else
                E.(sub_elem{k}){j,1} = S.(elem){j}.(sub_elem{k}).Text;
            end
        end
    end
    
    if any(iAttrib)
        attrib = fieldnames(S.(elem){j}.Attributes);
        for k = 1:length(attrib)
            [number,bOK] = str2num(S.(elem){j}.Attributes.(attrib{k}));
            if bOK
                E.(attrib{k})(j,1) = number;
            else
                E.(attrib{k}){j,1} = S.(elem){j}.Attributes.(attrib{k});
            end
        end
    end
end

if length(S.(elem)) == 1
    fields = fieldnames(E);
    for i = 1:length(fields)
        if iscell(E.(fields{i}))
            E.(fields{i}) = E.(fields{i}){1};
        else
            E.(fields{i}) = E.(fields{i})(1);
        end
    end
end