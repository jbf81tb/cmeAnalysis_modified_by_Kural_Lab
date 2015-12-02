function fxyc=TraceXYtofxyc(TraceX,TraceY)

[a,b]=size(TraceX);
L=zeros(1,a);
for i=1:a
    L(i)=length(find(TraceX(i,:)));
end
fxyc=zeros(max(L),4,a);
for i=1:a
    points=find(TraceX(i,:));
    for j=1:length(points)
        fxyc(j,1,i)=points(j);
        fxyc(j,2,i)=TraceX(i,points(j));
        fxyc(j,3,i)=TraceY(i,points(j));
        fxyc(j,4,i)=floor(L(i)/max(L)*63)+1;
    end
end