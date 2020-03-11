function setMatlabName(name)
jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
jDesktop.getMainFrame.setTitle(name);