function [x,info] = nleqn(f,x0,rtol,atol,ftol,varargin)
%NLEQN	Solve system of N nonlinear equations in N unknowns.
%   X = NLEQN(F,X0,RTOL) attempts to find an X close to initial guess X0
%   for which F(X) = 0.  F is a handle for the function that evaluates
%   F(X).  It must return a vector of the same length as vector X0.  If X
%   is not an acceptable argument for F, the function should return NaN.  
%   If  RTOL < 10*eps, it is increased to 10*eps.  The computed X satisfies
%   either NORM(error in X) <= RTOL*NORM(X) or NORM(F(X)) = 0.
%   
%   X = NLEQN(F,X0,RTOL,ATOL), with scalar ATOL >= 0, solves as above with
%   the convergence test on NORM(error in X) changed to NORM(error in X) <=
%   MAX(RTOL*NORM(X),ATOL).  If ATOL < 0, it is increased to 0.
%   
%   X = NLEQN(F,X0,RTOL,ATOL,FTOL), with scalar FTOL >= 0, solves as above 
%   with the test on F(X) changed to NORM(F(X)) <= FTOL.  If FTOL < 0, it 
%   is increased to 0.
%   
%   X = NLEQN(F,X0,RTOL,ATOL,FTOL,P1,P2,...) passes the additional
%   parameters P1,P2,... to the function F as F(X,P1,P2,...).
%   
%   [X,INFO] = NLEQN(...) returns a solution X and a flag INFO indicating
%   the status of the solution.  INFO = 0 indicates that one of the error
%   criteria is satisfied.  INFO = 1 indicates a failure to converge, and
%   INFO = 2 indicates an argument X was not acceptable to F.

%   This program was written by Lawrence F. Shampine and Mark W. Reichelt.
%   It is based on the FORTRAN program HYBRD1 of J.J. More', B.S. Garbow, 
%   and K.E. Hillstrom, User Guide for MINPACK 1, Argonne National Laboratory, 
%   Rept. ANL-80-74, 1980, which was itself based on the program CALFUN of 
%   M.J.D. Powell, A Fortran subroutine for solving systems of nonlinear 
%   algebraic equations, Chap. 7 in P. Rabinowitz, ed., Numerical Methods 
%   for Nonlinear Algebraic Equations, Gordon and Breach, New York, 1970.

x = x0(:);
n = length(x);
maxfev = 200*(n+1);

if (nargin < 3) || isempty(rtol)
  rtol = 1e-4;
else
  rtol = max(rtol,10*eps);
end
if (nargin < 4) || isempty(atol)
  atol = 0;
else
  atol = max(atol, 0);
end
if (nargin < 5) || isempty(ftol)
  ftol = 0;
else
  ftol = max(ftol, 0);
end    

% Evaluate the function at the initial guess.
Fx = feval(f,x,varargin{:});
nfev = 1;
if isnan(Fx)
  info = 2;
  return
end  
Fx = Fx(:);
Fnorm = norm(Fx);

% Initialize iteration counter and monitors.
iter = 1;
ncsuc = 0;
ncfail = 0;
nslow1 = 0;
nslow2 = 0;

% Initialize the step bound delta.
xnorm = norm(x);
delta = 100*xnorm;
if delta == 0 
  delta = 100;
end

Jac = zeros(length(Fx),n);
warnstat = warning;
warning('off');
while true    % Beginning of the outer loop.
  
  % Approximate the Jacobian matrix and factor it.
  jeval = true;
  xtry = x;
  for j = 1:n
    h = sqrt(eps)*abs(x(j));
    if h == 0
      h = sqrt(eps);
    end
    xtry(j) = x(j) + h;
    Fxtry = feval(f,xtry,varargin{:});
    if isnan(Fxtry)
      info = 2;
      return
    end
    Fxtry = Fxtry(:);
    Jac(:,j) = (Fxtry - Fx) / h;
    xtry(j) = x(j);
  end
  nfev = nfev + n;
  [Q,R] = qr(Jac);
  
  while true    % Beginning of the inner loop.
    % Backsolve to calculate the Gauss-Newton direction.  If necessary, make
    % small changes to the diagonal entries of R to make R*p = QtFx solvable.
    QtFx = Q.' * Fx;
    Rmod = R;
    for j = find(diag(Rmod) == 0)'
      Rmod(j,j) = eps*norm(R(:,j),Inf);
      if Rmod(j,j) == 0
        Rmod(j,j) = eps;
      end
    end
    p = -(Rmod \ QtFx);
    
    % Test whether the Gauss-Newton direction is acceptable.
    pnorm = norm(p);
    if pnorm > delta                    % if not acceptable
      % Calculate gradient direction.
      grad = R.' * QtFx;
      
      % Calculate norm of gradient and test for special case of zero gradient.
      gnorm = norm(grad);
      if gnorm ~= 0
        % Calculate point along gradient at which the quadratic is minimized.
        wa1 = grad / gnorm;
        temp = norm(R * wa1);
        sgnorm = (gnorm / temp) / temp;
        
        % Test whether the gradient direction is acceptable.
        if sgnorm < delta               % if not
          % Calculate point along dogleg at which the quadratic is minimized.
          Fxnorm = norm(QtFx);
          temp = (Fxnorm/gnorm) * (Fxnorm/pnorm) * (sgnorm/delta);
          temp = temp - (delta/pnorm)*(sgnorm/delta)^2 ...
              + sqrt((temp-(delta/pnorm))^2 ...
              + (1-(delta/pnorm)^2)*(1-(sgnorm/delta)^2));
          alpha = ((delta/pnorm)*(1 - (sgnorm/delta)^2))/temp;
        else
          alpha = 0;
        end
      
        % Form convex combination of Gauss-Newton and gradient directions.
        temp = (1 - alpha) * min(sgnorm, delta);
        p = -(temp*wa1 - alpha*p);
        pnorm = norm(p);
      else
        alpha = delta / pnorm;
        p = alpha*p;
        pnorm = alpha*pnorm;
      end
    end
    
    xtry = x + p;
    
    % On the first iteration, adjust the initial step bound.
    if iter == 1
      %      delta = min(delta,pnorm);   MINPACK version
      delta = max(0.1*delta,min(delta,pnorm));
    end
    
    % Evaluate the function at xtry.
    Fxtry = feval(f,xtry,varargin{:});
    if isnan(Fxtry)
      info = 2;
      warning(warnstat);
      return
    end
    Fxtry = Fxtry(:);
    nfev = nfev + 1;
    Fnorm1 = norm(Fxtry);
    
    % Compute the actual reduction.
    if Fnorm1 < Fnorm
      actred = 1 - (Fnorm1/Fnorm)^2;
    else
      actred = -1;
    end
    
    % Compute the predicted reduction.
    wa3 = QtFx + R * p;
    temp = norm(wa3);
    if temp < Fnorm
      prered = 1 - (temp/Fnorm)^2;
    else
      prered = 0;
    end
    
    % Compute the ratio of the actual to the predicted reduction.
    if prered > 0
      ratio = actred/prered;
    else
      ratio = 0;
    end
    
    % Update the step bound.
    if ratio < 0.1
      ncsuc = 0;
      ncfail = ncfail + 1;
      delta = delta / 2;
    else
      ncfail = 0;
      ncsuc = ncsuc + 1;
      if (ratio >= 0.5) || (ncsuc > 1)
        delta = max(delta,2 * pnorm);
      end
      if abs(ratio - 1) <= 0.1 
        delta = 2 * pnorm;
      end
    end
    
    % If successful, update x, Fx, and their norms.
    if ratio >= 0.0001
      x = xtry;
      Fx = Fxtry;
      xnorm = norm(x);
      Fnorm = Fnorm1;
      iter = iter + 1;
    end
    
    % Monitor the progress of the iteration.
    nslow1 = nslow1 + 1;
    if actred >= 0.001
      nslow1 = 0;
    end
    if jeval
      nslow2 = nslow2 + 1;
    end
    if actred >= 0.1
      nslow2 = 0;
    end
    
    % Test for convergence, too much work, lack of progress:
    if (ncfail == 0 && (delta <= max(rtol*xnorm,atol))) || (Fnorm <= ftol) 
      info = 0;
      warning(warnstat);
      return;                   
    elseif (nfev >= maxfev) || (0.1*max(0.1*delta,pnorm) <= eps*xnorm) || ...
           (nslow1 == 10) || (nslow2 == 5)
      info = 1;
      warning(warnstat);
      return; 
    end
    
    % Criterion for recalculating Jacobian approximation.
    if ncfail == 2
      break;
    end
    
    % Calculate rank one modification to the Jacobian and refactor.
    % Note that it is formulated in terms of a modification of R.
    wa1 = p / pnorm;
    wa2 = (Q.'*Fxtry - wa3) / pnorm;
    Jac = Q * (R + wa2*wa1.');
    [Q,R] = qr(Jac);
    
    jeval = false;
  end     % End of the inner loop.
  
end    % End of the outer loop.