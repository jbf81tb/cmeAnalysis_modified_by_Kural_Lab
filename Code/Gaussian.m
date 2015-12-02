function z = Gaussian( w, points )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x0=w(1);
A=w(2);
s=w(3);
z=zeros(1,length(points));
for i=1:length(points)
z(i)=A*exp(-(points(i)-x0)^2/(2*s^2));
end