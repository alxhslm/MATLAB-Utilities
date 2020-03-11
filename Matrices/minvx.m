function I = minvx(M)
if size(M,1) == 1
    I = 1./M;
elseif size(M,1) == 2
    det = M(1,1,:).*M(2,2,:) - M(1,2,:).*M(2,1,:);
    I = [M(2,2,:) -M(1,2,:);
        -M(2,1,:)  M(1,1,:)]./det;
else
    ind = 1:size(M,1);
    Cf = 0*M;
    for i = 1:size(M,1)
        for j = 1:size(M,1)
            Cf(i,j,:) = detx(M(ind~=i,ind~=j,:))*(2*(mod(i+j,2) == 0)-1);
        end
    end
    det = sum(M(1,:,:).*Cf(1,:,:),2);
    I = permute(Cf,[2 1 3])./det;
end