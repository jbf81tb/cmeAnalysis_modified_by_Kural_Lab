function [life]=LifetimeVFrameFinder(TraceINT)
[a,b]=size(TraceINT);
count=zeros(1,b);
sum=zeros(1,b);
for i=1:a
    frames=find(TraceINT(i,:));
    slife=length(frames);
    if slife>5
        for j=1:slife
            count(frames(j))=count(frames(j))+1;
            sum(frames(j))=sum(frames(j))+slife;
        end
    end
end
for i=1:b
    if sum(i)~=0
        life(i)=sum(i)/count(i);
    else
        life(i)=0;
    end
end