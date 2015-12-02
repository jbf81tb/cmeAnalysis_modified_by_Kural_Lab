for i=1:6
    T=array{i};
    [A(i),B(i),C(i)]=size(T);
end
Threshfxyc=zeros(max(A),max(B),max(C));
used=0;
h=waitbar(0,'Combining Threshfxycs');
for i=1:6
    T=array{i};
    for i2=1:A(i)
        waitbar((i-1)/6+i2/A(i)/6)
        for i3=1:B(i)
            for i4=1:C(i)
                Threshfxyc(i2,i3,i4+used)=T(i2,i3,i4);
            end
        end
    end
    used=used+C(i);
end
close(h)