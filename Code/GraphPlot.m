for i=1:1000
    y(i)=2*exp(-(i-1)/10)-exp(-(i-1)/5);
    x(i)=i-1;
end
plot(x,y)
xlim([0 50])
xlabel('Time')
ylabel('Reactant Number')
