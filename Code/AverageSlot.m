function fxyc=AverageSlot(fxyc,slot,newslot)

for i=1:length(fxyc(1,1,:))
    used=find(fxyc(:,slot,i));
    values=fxyc(used,slot,i);
    av=mean(values);
    for i2=1:length(used)
        fxyc(used(i2),newslot,i)=av;
    end
end