function k = findrows(A,type)
%Finds locations k(i) of final non-zero value in each row A(i,:), with k(i)=NaN if 
%the entire row is zero.

if nargin < 2
    type = 'first';
end

m=size(A,2);
if strcmpi(type,'first')
    [val,loc] = max(  logical(A),  [],2);
    k = loc;
elseif strcmpi(type,'last')
    [val,loc] = max(  fliplr(logical(A)),  [],2);
    k=m+1-loc;
end

k(val==0)=NaN;
