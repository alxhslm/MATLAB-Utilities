function s = getsubfield(S,fields) %#ok
s = eval(sprintf('S.%s;',fields));