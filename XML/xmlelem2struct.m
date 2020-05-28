function S = xmlelem2struct(Element)
f = fieldnames(Element);
f = f(~strcmp(f,'Attributes'));
for i = 1:length(f)
    SubElem = Element.(f{i});
    if iscell(SubElem)
        for j = 1:length(SubElem)
            S.(f{i})(j,1) = xmlelem2struct(SubElem{j});
        end
    elseif isfield(SubElem,'Text')
        [number, bOK] = str2num(SubElem.Text);
        if bOK
            S.(f{i}) = number;
        else
            S.(f{i}) = SubElem.Text;
        end
    else
        S.(f{i}) = xmlelem2struct(SubElem);
    end
end
if isfield(Element,'Attributes')
    Attr = Element.Attributes;
    f = fieldnames(Attr);
    for i = 1:length(f)
        [number, bOK] = str2num(Attr.(f{i}));
        if bOK
            Attr.(f{i}) = number;
        end
    end
    S = structmerge(S,Attr);
end