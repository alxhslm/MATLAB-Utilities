function git(varargin)
[~,result] = system(['git ' sprintf('%s ', varargin{:})]);
disp(result)