function [p,Yfit,err] = modelfit(X,Y,fun,p0,pLB,pUB,wt,varargin)

if nargin < 5 || isempty(pLB)
    pLB = p0 - Inf;
end
if nargin < 6 || isempty(pUB)
    pUB = p0 + Inf;
end
if nargin < 7 || isempty(wt)
    wt = X(:,1)*0 + 1;
end

options = optimoptions('fmincon','Display','iter','TolX',1E-12,'TolFun',1E-6);
[p,err,flag] = fmincon(@(p)objfun(p,fun,X,Y,wt,varargin{:}),p0,[],[],[],[],pLB,pUB,[],options);
bSuccess = any(flag == [1 2]);
% options = struct();
% [p,info] = fipopt(@(p)objfun(p,fun,X,Y,wt,varargin{:}),p0,[],options,varargin{:});
% bSuccess = info.status == 0;
if 0%~bSuccess
    p = p + NaN;
end
Yfit = feval(fun,p,X,varargin{:});

function obj = objfun(p,fun,X,Y,wt,varargin)
Yfit = feval(fun,p,X,varargin{:});
obj = mean(wt.*sum((Y - Yfit).^2,2),1);