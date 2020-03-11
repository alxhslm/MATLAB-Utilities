function R = rotation(a)
%ROTATION MATRIX Simple rotation about z axis
R = [cos(a) -sin(a);
     sin(a)  cos(a)];
