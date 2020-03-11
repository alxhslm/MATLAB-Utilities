function M = nanmean(varargin)
M = nanfunc(@mean,varargin{:});