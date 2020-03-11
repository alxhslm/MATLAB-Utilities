function varargout = bash(input)
output = dos(['"C:\Program Files\Git\bin\sh.exe" --login -i -c',' "',input,'"']);
if nargout > 0
    varargout{1} = output;
end