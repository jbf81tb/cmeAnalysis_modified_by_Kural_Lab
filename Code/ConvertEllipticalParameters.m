function [ecc,area]=ConvertEllipticalParameters(a,b,c)

n=sign(det([[a b];[b c]]));
if n==-1
    ecc=-1;
    area=-1;
else
ecc=sqrt(2*sqrt((a-c)^2+b^2*4)/(n*(a+c)+sqrt((a-c)^2+4*b^2)));
area=pi/sqrt(a*c-b^2);
end