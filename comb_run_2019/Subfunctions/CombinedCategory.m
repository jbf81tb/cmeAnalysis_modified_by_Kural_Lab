function C=CombinedCategory(Beg,Fin)

[a,b]=size(Beg);
for i=1:a
    for i2=1:b
        B=Beg(i,i2);
        F=Fin(i,i2);
        if B==1 && F==1
            C(i,i2)=3;
        end
        if B==1 && F==0
            C(i,i2)=1;
        end
        if B==0 && F==1
            C(i,i2)=2;
        end
        if B==0 && F==0
            C(i,i2)=4;
        end
    end
end