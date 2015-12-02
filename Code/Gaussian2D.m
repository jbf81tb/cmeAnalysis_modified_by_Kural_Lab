function z = Gaussian2D( w, points )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x0=w(1);
y0=w(2);
A=w(3);
s=w(4);
x=points(:,1);
y=points(:,2);
for i=1:length(x)
z(i)=A*exp(-(x(i)-x0)^2/(2*s^2)-(y(i)-y0)^2/(2*s^2));
end



