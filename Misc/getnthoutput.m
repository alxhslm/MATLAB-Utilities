function out = getnthoutput(i,n,fun,varargin)
[outputs{1:n}] = feval(fun,varargin{:});
out = outputs{i};