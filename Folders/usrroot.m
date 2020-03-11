function loc = usrroot
if isunix
    root = '/Users/';
elseif strcmp(computer,'PCWIN64')
    root = 'c:\Users\';
end

loc = [root username];