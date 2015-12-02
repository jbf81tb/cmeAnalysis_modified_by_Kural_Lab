function life=SimplifiedMakeLifetimeVector(path,FrameGap)

%parameters to be set
fxyc=[];
load(path) %where the trace data is stored
%FrameGap=1; %seconds per frame


if isempty(fxyc)
    fxyc=Threshfxyc;
end
frames=max(max(fxyc(:,1,:)));
[TraceX,TraceY,TraceZ,TraceINT]=fxyc2TraceXY(fxyc,frames,3);
[life]=LifetimeAnalysis(TraceINT,FrameGap);