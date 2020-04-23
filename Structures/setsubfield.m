function S = setsubfield(S,fields,v)%#ok
eval(sprintf('S.%s = v;',fields));