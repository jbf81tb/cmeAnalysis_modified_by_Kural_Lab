F = @(back, amp, x0, y0, a, b, c, x, y)back+amp*exp(-a*(x-x0).^2-2*b*(x-x0).*(y-y0)-c*(y-y0).^2);
F(1,2,3,4,5,6,7,8,9)