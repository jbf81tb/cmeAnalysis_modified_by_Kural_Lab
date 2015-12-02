function [A]=LifetimeVStartFrame(TraceINT,FrameGap)

[a,b]=size(TraceINT);
indices=zeros(1,b)+2;
for i=1:b
    A(i+1,1)=i;
end
for i=1:a
    frames=find(TraceINT(i,:));
    A(frames(1)+1,indices(frames(1)))=length(frames)*FrameGap;
    indices(frames(1))=indices(frames(1))+1;
end