a=length(x);
num=0;
for i=1:a
    for j=1:a
        if (x(i)-x(j))^2+(y(i)-y(j))^2<=1
            num=num+1;
        end
    end
end