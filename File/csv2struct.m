function S = csv2struct(file)
fid = fopen(file);
fields = textscan(fid,['%s' repmat('%s',1,50)],1,'Delimiter',',','CollectOutput',true);
fields = fields{1};
fields = fields(~cellfun(@isempty,fields));
fclose(fid);

Data = csvread(file,1);
for k = 1:length(fields)
    S.(fields{k}) = Data(:,k);
end