function M = nanrange(varargin)
M = nanfunc(@(x)(max(x)-min(x)),varargin{:});