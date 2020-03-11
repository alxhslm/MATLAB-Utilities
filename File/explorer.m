function explorer(varargin)

if nargin > 1
    for i = 1:nargin
        explorer(varargin{i})
    end
    return;
elseif nargin < 1
    path = pwd;
else
    file = varargin{1};
    [path,file,ext] = fileparts(file);
    if isempty(path)
        [path,~,~] = fileparts(which(file));
    else
        if isempty(ext)
            path = fullfile(path,file);
        end
    end
end

if strcmp(computer,'PCWIN64')
    exe = 'explorer';
elseif strcmp(computer,'MACI64')
    exe = 'open';
elseif strcmp(computer,'GLNXA64')
    exe = 'nautilus';
end

system([exe ' "' path '"']);

