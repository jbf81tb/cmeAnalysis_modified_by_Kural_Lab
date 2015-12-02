function L=LifetimeAnalysis(TraceX,FrameGap)

[a,b]=size(TraceX);

for i=1:a
    L(i)=length(find(TraceX(i,:)))*FrameGap;
end