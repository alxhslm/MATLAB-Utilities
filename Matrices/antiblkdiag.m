function a = antiblkdiag(varargin)
for i = 1:nargin
    varargin{i} = fliplr(varargin{i});
end
a = fliplr(blkdiag(varargin{:}));