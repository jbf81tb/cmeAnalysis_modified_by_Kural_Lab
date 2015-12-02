function fxyc=AverageAboveR2(fxyc,slot,newslot,R2Bound)

for i=1:length(fxyc(1,1,:))
    used=find(fxyc(:,9,i)>=R2Bound);
    usedt=find(fxyc(:,1,i));
    if length(used)>=5
        values=fxyc(used,slot,i);
        sorted=sort(values);
        last=find(sorted,5,'last');
        av=mean(sorted(last));
        for i2=1:length(usedt)
            fxyc(usedt(i2),newslot,i)=av;
        end
    else
        for i2=1:length(usedt)
            fxyc(usedt(i2),newslot,i)=-1;
        end
    end
end