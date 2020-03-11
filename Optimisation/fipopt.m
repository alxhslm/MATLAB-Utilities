function [x,info] = fipopt(obj_fun,x0,constr_fun,options,varargin)
% FIPOPT - wrapper for IP-OPT mex interface, to make it more like fmincon.
%
% Syntax:
%  [x,info] = fipopt(obj_fun,x0,constr_fun,options,[...])
%
% Inputs:
%
%   obj_fun    :  objective function of the form g = obj_fun(x,[...])
%   x0         :  initial guess
%   constr_fun :  constraint function of the form f = constr_fun(x,[...])
%   options    :  ipopt options structure
%   [...]      :  extra arguments to be passed to objective/constraint functions
%
% Outputs:
%
%   x          : solution
%   info       : structure from ipopt specifying status, no. of iterations etc.
%
% Options:
%
%   maxit             : max no. of iterations
%   print_level       : max no. of iterations
%   ftol              : constraint violation tolerance
%   xtol              : solution tolerance
%   gradient          : function of the form dg_dx = grad_fun(x,[...]) returning the analytical gradient
%   jacobian          : function of the form df_dx = jacob_fun(x,[...]) returning the analytical jacobian
%   jacobianstructure : function of the form S = jacobstruct_fun(x,[...]) or a constant  matrix
% Author - A. H. Haslam (c) 2018

if nargin < 4
    options = struct();
end
options = default_options(options,x0);

ipopt_options.ipopt.hessian_approximation = 'limited-memory';
ipopt_options.ipopt.print_level = options.print_level;
ipopt_options.ipopt.max_iter = options.maxit;
ipopt_options.ipopt.constr_viol_tol = options.ftol;
ipopt_options.ipopt.tol = options.xtol;
ipopt_options.ipopt = structmerge(ipopt_options.ipopt,options.ipopt);

funcs.iterfunc = @iteration;
%objective
if isempty(obj_fun)
    funcs.objective = @(x)0;
else
    funcs.objective = @(x)obj_fun(x,varargin{:});
end

%gradient
if isfield(options,'gradient')
    %analytical
    funcs.gradient = @(x)options.gradient(x,varargin{:});
else
    %numerical
    funcs.gradient = @(x)jacobian(funcs.objective,x);
end

%constraints
if isempty(constr_fun)
    funcs.constraints = @(x)[];
else
    funcs.constraints = @(x)constr_fun(x,varargin{:});
end

%call constraint function to get number of constraints
c0 = feval(funcs.constraints,x0);
ipopt_options.cl = 0*c0;
ipopt_options.cu = 0*c0;

ipopt_options.lb = options.lb;
ipopt_options.ub = options.ub;

%jacobian
if isfield(options,'jacobian')
    %analytical
    funcs.jacobian = @(x)sparse(options.jacobian(x,varargin{:}));
else
    %numerical
    funcs.jacobian = @(x)sparse(jacobian(funcs.constraints,x));
end

%sparsity
if isfield(options,'jacobianstructure')
    if ismatrix(options.jacobianstructure)
        funcs.jacobianstructure = @(x)sparse(options.jacobianstructure);
    else
        funcs.jacobianstructure = @(x)sparse(options.jacobianstructure(x,varargin{:}));
    end
else
    funcs.jacobianstructure = @(x)sparse(ones(length(c0),length(x0)));
end
        
%now make the acutal call to ipopt
[x,info] = ipopt_auxdata(x0,funcs,ipopt_options);

function J = jacobian(fun,x,varargin)
f0 = feval(fun,x,varargin{:});
h = 1E-10+1E-8*abs(x(:));

x = x(:);
J = f0 *x'*0;
x0 = x;
for i = 1:length(x)
    x = x0;
    x(i,:) = x(i,:) + h(i);
    f = feval(fun,x,varargin{:});
    J(:,i) = (f - f0)./h(i);
end

function options = default_options(options,x0)
if ~isfield(options,'maxit')
    options.maxit = 50;
end
if ~isfield(options,'print_level')
    options.print_level = 5;
end
if ~isfield(options,'ftol')
    options.ftol = 1E-6;
end
if ~isfield(options,'xtol')
    options.xtol = 1E-6;
end
if ~isfield(options,'ipopt')
    options.ipopt = struct();
end
if ~isfield(options,'lb')
    options.lb = x0-Inf;
end
if ~isfield(options,'ub')
    options.ub = x0+Inf;
end