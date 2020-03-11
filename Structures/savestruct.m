function savestruct(file,name)
s = evalin('caller',name);
save(file,'-struct','s');