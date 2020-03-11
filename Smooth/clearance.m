function x = clearance(x,c)
if c > 0
    x = max(x-c,0) + min(x+c,0);
end