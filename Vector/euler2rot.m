function R = euler2rot(ax,theta)
R = eye(3);
for i = 1:3
   R = rodrigues(ax(i),theta(i))*R;
end