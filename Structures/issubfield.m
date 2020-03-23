function b = issubfield(S,fields)
b = true;
try
    getsubfield(S,fields);
catch
    b = false;
end  