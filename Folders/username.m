function user_name = username
if isunix
    [~, user_name] = system('whoami');
    user_name = user_name(1:end-1);
elseif strcmp(computer,'PCWIN64')
    user_name = getenv('USERNAME');
end