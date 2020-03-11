function chrome(url)
if nargin < 1
    url = '';
end    

if strcmp(computer,'PCWIN64')
    exe = '"C:\Program Files (x86)\Google\Chrome\Application\Chrome.exe"';
elseif strcmp(computer,'MACI64')
    exe = 'open -a /Applications/GoogleChrome.app';
end

system([exe ' ' url]);