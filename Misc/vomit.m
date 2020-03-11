function vomit
p = evalin('caller','who');
for i = 1:length(p)
    assignin('base',p{i},evalin('caller',p{i}));
end