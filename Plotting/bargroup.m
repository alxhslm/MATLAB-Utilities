function b = bargroup(varargin)
% bargroup Grouped bar graph.
%     bargroup(X,Y) draws the columns of the M-by-N matrix Y as M groups of
%     N vertical bars.  The vector X must not have duplicate values.
%  
%     bargroup(Y) uses the default value of X=1:M.  For vector inputs, 
%     bargroup(X,Y) or bar(Y) draws LENGTH(Y) bars.  The colors are set by
%     the colormap.
%
%     bargroup(X,Y,BARWIDTH) or bargroup(Y,BARWIDTH) specifies the width of
%     the bars. Values of BARWIDTH > 1, produce overlapped bars. The default
%     value is BARWIDTH=0.8
%  
%     bargroup(X,Y,BARWIDTH,GROUPWIDTH) or bargroup(Y,BARWIDTH,GROUPWIDTH)
%     specifies the width of the bar groups. Values of GROUPWIDTH > 1, 
%     produce overlapped bar groups.  The default value is GROUPWIDTH=0.5
% 
%     bargroup(...,COLOR) uses the line color specified.  Specify the color as one of
%     these values: 'r', 'g', 'b', 'y', 'm', 'c', 'k', or 'w'.
%  
%     bargroup(AX,...) plots into AX instead of GCA.
%  
%     H = bargroup(...) returns a vector of handles to Bar objects.
% 

if ishandle(varargin{1})
    ax = varargin{1};
    varargin = varargin(2:end);
else
    ax = gca;
end

bChar = cellfun(@ischar,varargin);

%trim off P-V pairs
if any(bChar)
    iTrim = (find(bChar,1)-1);
    args = varargin(1:iTrim);
    pv = varargin((iTrim+1):end);
else
    args = varargin;
    pv = {};
end

P.barwidth = 0.8;
P.groupwidth = 0.6;
f = {'groupwidth','barwidth'};
count = 1;
for i = length(args):-1:1
    if isscalar(args{i})
        P.(f{count}) = args{i};
        count = count + 1;
    end
end

args = args(1:end+1-count);

if length(args) > 1
    x = args{1};
    y = args{2};
else
    y = args{1};
    x = 1:size(y,1);
end

N = size(y,2);
dx = min(diff(x));
dg = P.groupwidth / N * dx;

xd = (1:N); 
xd = xd - mean(xd);
xd = xd * dg;

w = P.barwidth*dg/dx;
bHold = ishold(ax);
hold on
for i = 1:N
    b(i) = bar(ax,x + xd(i), y(:,i), w, pv{:});
end

%reset hold state
if ~bHold
    hold off;
end

