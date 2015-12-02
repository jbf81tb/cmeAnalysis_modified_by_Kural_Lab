function fxyc=AverageAboveThresh(fxyc,slot,newslot,Thresh)

for i=1:length(fxyc(1,1,:))
    used=find(fxyc(:,5,i)>=Thresh);
    usedt=find(fxyc(:,1,i));
    if ~isempty(used)
    values=fxyc(used,slot,i);
    av=mean(values);
    for i2=1:length(usedt)
        fxyc(usedt(i2),newslot,i)=av;
    end
    end
end