function fxyc=Holefillerfxyc(fxyc)
if isempty(fxyc), return; end
[a,b,c]=size(fxyc);
for i1=1:c
    first=find(fxyc(:,1,i1),1,'first');
    last=find(fxyc(:,1,i1),1,'last');
    i2=first;
    while i2<last
        if fxyc(i2,1,i1)==0
            f=fxyc(i2-1,1,i1);
            x=fxyc(i2-1,2,i1);
            y=fxyc(i2-1,3,i1);
            int=0;
            fxyc=AddSorted5Int(f,x,y,int,fxyc,i1);
        end
        last=find(fxyc(:,1,i1),1,'last');
        i2=i2+1;
    end
end