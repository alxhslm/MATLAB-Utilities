function onedrive(file)

url = 'https://imperiallondon-my.sharepoint.com/personal/ahh316_ic_ac_uk/_layouts/15/onedrive.aspx?id=%2fpersonal%2fahh316_ic_ac_uk%2fDocuments';

path = which(file);
if isempty(path)
    disp('File not found')
    return
end
path = fileparts(path);

onedrv = onedriveroot;

path = path(length(onedrv)+1:end);
path = strrep(path,filesep,'%2f');
path = strrep(path,' ','+');
url = [url path];
chrome(url);