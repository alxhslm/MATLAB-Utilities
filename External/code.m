function code(varargin)
if ~nargin
    docs = matlab.desktop.editor.getAll;
    files = sprintf('"%s" ',docs.Filename);
else
    for i = 1:nargin
        files{i} = which(varargin{i});
    end
    files = sprintf('"%s" ',files{:});
end

if strcmp(computer,'PCWIN64')
    exe = '"C:\Program Files\Microsoft VS Code\Code.exe"';
elseif strcmp(computer,'MACI64')
    exe = 'open -a /Applications/Visual\ Studio\ Code.app';
end

system([exe ' ' files]);
