function FL=FrameLifetime(fxyc,frames)
clear Complete TraceNum LifetimeSum Life FrameLifetime
Complete=find(fxyc(1,4,:)==3);
TraceNum=zeros(1,frames);
LifetimeSum=zeros(1,frames);
Life=zeros(1,length(Complete));
for j=1:length(Complete)
    f=find(fxyc(:,1,Complete(j)));
    Life(j)=max(f)-min(f);
end
for j=1:length(Complete)
    for i=1:length(fxyc(:,1,1))
        if fxyc(i,1,Complete(j))~=0
        TraceNum(fxyc(i,1,Complete(j)))=TraceNum(fxyc(i,1,Complete(j)))+1;
        LifetimeSum(fxyc(i,1,Complete(j)))=LifetimeSum(fxyc(i,1,Complete(j)))+Life(j);
        end
    end
end
for i=1:frames
    if TraceNum(i)~=0
        FL(i)=LifetimeSum(i)/TraceNum(i);
    else
        FL(i)=0;
    end
end