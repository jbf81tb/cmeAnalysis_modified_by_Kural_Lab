function [life]=LifetimeHistogram(TraceINT,FrameGap)

[a,b]=size(TraceINT);
life=zeros(1,a);
for i=1:a
    frames=find(TraceINT(i,:));
    life(i)=length(frames)*FrameGap;
    
end
