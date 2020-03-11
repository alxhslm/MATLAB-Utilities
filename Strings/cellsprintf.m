function C = cellsprintf(format,varargin)
if isnumeric(varargin{1})
    varargin{1} = num2cell(varargin{1});
end
%create the function handle for sprintf with variable arguments
fun = @(varargin)sprintf(format,varargin{:});

%now call sprintf using cellfun
C = cellfun(fun,varargin{:},'UniformOutput',false);