function Cplot=ColorReplace(Trace)

[a,b]=size(Trace);
Cplot=zeros(a,b);
for i=1:a
    for j=1:b
        if Trace(i,j)==1
            Cplot(i,j)=64;
        end
        if Trace(i,j)==2
            Cplot(i,j)=3;
        end
        if Trace(i,j)==3
            Cplot(i,j)=2;
        end
    end
end