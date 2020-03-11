function swap(name1,name2)
val1 = evalin('caller',name1);
val2 = evalin('caller',name2);
tmp = val1;
val1 = val2;
val2 = tmp;

assignin('caller',name1,val1)
assignin('caller',name2,val2)