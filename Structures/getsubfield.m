function s = getsubfield(S,fields)
f = split(fields,'.')';
s = getfield(S,f{:});