function file = filename(str)
if iscell(str)
    for i = 1:length(str)
        file{i} = filename(str{i});
    end
    return
end
[~,file,ext] = fileparts(str);
if ~isempty(ext)
    file = [file '.' ext];
end