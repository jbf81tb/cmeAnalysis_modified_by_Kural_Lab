function [fxyc,check]=fxycHoleFiller(fxyc)

[A,B,C]=size(fxyc);
check=0;
for i=1:C
    used=nonzeros(fxyc(:,1,i));
    for i2=min(used):max(used)
        if isempty(find(used==i2))
            copy=find(fxyc(:,1,i)==i2-1);
            frame=i2;
            x=fxyc(copy(1),2,i);
            y=fxyc(copy(1),3,i);
            fxyc=AddSorted(frame,x,y,0,fxyc,i);
            check=check+1;
        end
    end
end