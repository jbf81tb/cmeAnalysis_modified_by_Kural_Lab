function [IMat,CMat]=SimplifiedMakeInitiationVectorWPositions(path)

%parameters to be set
fxyc=[];
load(path) %where the trace data is stored
%FrameGap=1; %seconds per frame


if isempty(fxyc)
    fxyc=Threshfxyc;
end
frames=max(max(fxyc(:,1,:)));
[IMat,CMat]=InitiationAnalysis(fxyc);