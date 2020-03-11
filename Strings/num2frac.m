function s = num2frac(n)
[num,den] = rat(n);
if den == 1
    s = num2str(num);
else
    s = [num2str(num) '/' num2str(den)];
end