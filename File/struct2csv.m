function struct2csv(S,file)
fields = fieldnames(S);
for i = 1:length(fields)
    Data(:,i) = S.(fields{i});
end

%create header
header = sprintf('%s, ',fields{:});

fid = fopen(file,'w');
fprintf(fid,'%s\n',header);
fclose(fid);

dlmwrite(file,Data,'Delimiter',',','-append');