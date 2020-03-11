function det = detx(M)
if size(M,1) == 1
    det = M;
elseif size(M,1) == 2
    det = M(1,1,:).*M(2,2,:) - M(1,2,:).*M(2,1,:);
else
    det = 0;
    ind = 1:size(M,1);
    for j = 1:size(M,1)
        det = det + M(1,j)*detx(M(ind>1,ind~=j,:))*(2*(mod(j,2) ~= 0)-1);
    end
end