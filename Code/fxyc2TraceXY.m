function [TraceX,TraceY,TraceZ,TraceINT]=fxyc2TraceXY(fxyc,frames,mode)

[dim1,dim2,dim3]=size(fxyc);
index=1;
for i=1:dim3
    if mode==1 || mode==5 % include all traces
        Newfxyc(:,:,index)=fxyc(:,:,i);
        L(index)=length(find(Newfxyc(:,5,index)));
        index=index+1;
    end
    if mode==2 %only include full traces
        if fxyc(1,4,i)==3
            Newfxyc(:,:,index)=fxyc(:,:,i);
            L(index)=length(find(Newfxyc(:,5,index)));
            index=index+1;
        end
    end
    if mode==3 %include all traces that aren't cut off by the ends of the movies
        if fxyc(1,4,i)<=4
            Newfxyc(:,:,index)=fxyc(:,:,i);
            L(index)=length(find(Newfxyc(:,5,index)));
            index=index+1;
        end
    end
    if mode==4 %include beginnings and ends, but not both in the same trace
        if fxyc(1,4,i)==1 || fxyc(1,4,i)==2
            Newfxyc(:,:,index)=fxyc(:,:,i);
            L(index)=length(find(Newfxyc(:,5,index)));
            index=index+1;
        end
    end
end
fxyc=Newfxyc;
[dim1,dim2,dim3]=size(fxyc);
TraceX=zeros(dim3,frames);
TraceY=zeros(dim3,frames);
TraceZ=zeros(dim3,frames);
TraceINT=zeros(dim3,frames);
for k=1:dim3
    TraceL=find(fxyc(:,1,k));
    for i=1:length(TraceL)
        TraceX(k,fxyc(TraceL(i),1,k))=fxyc(TraceL(i),2,k);
        TraceY(k,fxyc(TraceL(i),1,k))=fxyc(TraceL(i),3,k);
        if mode~=4 && mode~=5
            TraceZ(k,fxyc(TraceL(i),1,k))=1+floor(L(k)/max(L)*63);                 %fxyc(TraceL(i),4,k);
        else
            if mode==5
                TraceZ(k,fxyc(TraceL(i),1,k))=fxyc(TraceL(i),7,k);
            else
            TraceZ(k,fxyc(TraceL(i),1,k))=(fxyc(TraceL(i),4,k)-1)*63+1;
            end
        end
        TraceINT(k,fxyc(TraceL(i),1,k))=fxyc(TraceL(i),5,k);
    end
end
