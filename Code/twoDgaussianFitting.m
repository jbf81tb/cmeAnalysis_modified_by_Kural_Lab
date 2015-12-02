function [c,R2] = twoDgaussianFitting(img)
% c(1) = background
% c(2) = amplitude
% c(3) = x center
% c(4) = y center
% c(5) = a
% c(6) = b
% c(7) = c

%img = imread(imgfile);
[ydata, xdata] = meshgrid(1:size(img,2), 1:size(img,1));
F = @(back, amp, x0, y0, a, b, c, x, y)back+amp*exp(-a*(x-x0).^2-2*b*(x-x0).*(y-y0)-c*(y-y0).^2);
c0 = double([mean(min(img)) max(img(:)) size(img,2)/2 size(img,1)/2 .5 0 .5]);
low = double([min(img(:)) mean(img(:))-min(img(:)) 1 1 0 -50 0]);
up = double([mean(img(:)) 1.1*(max(img(:))-min(img(:))) size(img,1) size(img,2) 50 50 50]);
xdata = double(xdata); ydata = double(ydata); img = double(img);
gfit = fit([xdata(:), ydata(:)], img(:), F, 'StartPoint', c0,'Lower', low, 'Upper', up);
%plot(gfit, [xdata(:), ydata(:)], img(:));
c = coeffvalues(gfit);
SStot=0;
SSres=0;
row=img(:);
av=mean(img(:));
for i=1:length(xdata)
    fitv=F(c(1),c(2),c(3),c(4),c(5),c(6),c(7),xdata(i),ydata(i));
    SStot=SStot+(row(i)-av)^2;
    SSres=SSres+(row(i)-fitv)^2;
end
R2=1-SSres/SStot;
end