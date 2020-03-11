function notepad(varargin)
if ~nargin
    docs = matlab.desktop.editor.getAll;
    files = sprintf('"%s" ',docs.Filename);
else
    for i = 1:nargin
        files{i} = varargin{i};
        if isempty(fileparts(files{i}))
            files{i} = which(files{i});
        end
    end
    files = sprintf('"%s" ',files{:});
end

if strcmp(computer,'PCWIN64')
    exe = '"C:\Program Files\Notepad++\notepad++.exe"';
elseif strcmp(computer,'MACI64')
    exe = 'open -a /Applications/TextWrangler.app';
end

system([exe ' ' files]);
