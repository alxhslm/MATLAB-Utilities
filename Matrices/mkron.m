function C = mkron(A,B)

C = [];
for i = 1:size(A,1)
    row = [];
    for j = 1:size(A,2)
        row = [row A(i,j,:).*B];
    end
    C = [C; row];
end