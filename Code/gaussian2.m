function y = gaussian(x,xdata)
% x is a vector of arguments to be minimized for; 
[a b c]=x;
% The quantities a, b and c describe your Gaussian shape
% xdata = the data points at which to calculate the Gaussian

y = a * exp(-((xdata-b)/c)^2); % Compute function values at xdata