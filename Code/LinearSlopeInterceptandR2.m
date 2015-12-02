function [slope, intercept, rsq]=LinearSlopeInterceptandR2(x,y) %Gives you the slope and R^2 value for the data x,y

p=polyfit(x,y,1);
slope=p(1);
intercept=p(2);
yfit = polyval(p,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;