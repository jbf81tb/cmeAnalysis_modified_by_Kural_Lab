function Y=sigmoid(X)

[a,b]=size(X);
Y=zeros(size(X));
for i=1:a
    for i2=1:b
        Y(i,i2)=1/(1+exp(-X(i,i2)));
    end
end