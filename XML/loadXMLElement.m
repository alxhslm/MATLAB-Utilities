function S = loadXMLElement(Element)
f = fieldnames(Element);
f = f(~strcmp(f,'Attributes'));
for i = 1:length(f)
    SubElem = Element.(f{i});
    if iscell(SubElem)
        for j = 1:length(SubElem)
            S.(f{i})(j,1) = loadXMLElement(SubElem{j});
        end
    elseif isfield(SubElem,'Text')
        [number, bOK] = str2num(SubElem.Text);
        if bOK
            S.(f{i}) = number;
        else
            S.(f{i}) = SubElem.Text;
        end
    else
        S.(f{i}) = loadXMLElement(SubElem);
    end
end
if isfield(Element,'Attributes')
    S = structmerge(S,Element.Attributes);
end