function compare(varargin)
for i = 1:nargin
    files{i} = which(varargin{i});
end

for i = 1:2:nargin
    if strcmp(computer,'PCWIN64')
        system(['"C:\Program Files (x86)\WinMerge\WinMergeU.exe" ' sprintf('"%s" ',files{i:i+1})]);
    elseif strcmp(computer,'MACI64')
        system(sprintf('open -n -a Meld --args "%s" "%s"',files{i}, files{i+1}));
    end
end