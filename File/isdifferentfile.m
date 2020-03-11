function b = isdifferentfile(file_name_1,file_name_2)

if any(strcmp(computer,{'MACI64','GLNXA64'}))
    cmd = 'diff';
elseif strcmp(computer,'PCWIN64')
    cmd = 'fc';
end

[status,result] = system([cmd ' "' file_name_1 '" "' file_name_2 '"']);
b = status > 0;