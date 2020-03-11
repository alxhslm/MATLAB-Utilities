function str = standardform(x,n)
if nargin < 2
    n = 1;
end
string = sprintf(['%.' num2str(n-1) 'e'], x); % Convert number to a scientific notation string with 2 decimal places of precision
stringParts = strsplit(string,'e'); % Split the string where 'e' is
firstPart = stringParts{1}; % Get the 1st part of stringParts which is the first part of standard form.
secondPart = ['10^{' num2str(str2double(stringParts{2})) '}'];

str = ['$' firstPart '\times' secondPart '$'];