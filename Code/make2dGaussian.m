function IMG=make2dGaussian(a,b,c)

IMG=zeros(7);
for i1=-3:3
    for i2=-3:3
        IMG(i1+4,i2+4)=exp(-(a*i1^2+b*i1*i2+c*i2^2));
    end
end