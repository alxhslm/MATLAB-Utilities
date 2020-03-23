function S = setsubfield(S,fields,v)
    f = split(fields,'.')';
    S = setfield(S,f{:},v);