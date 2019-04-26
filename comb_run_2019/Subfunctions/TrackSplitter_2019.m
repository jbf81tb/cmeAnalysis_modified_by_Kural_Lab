function fxycS=TrackSplitter_2019(fxycS,Data,used,framegap)

F1min=[.5 .95];%[.9 .998]; %Min trace F1s to override criterion that F1s must increase on splits
                %Both subsections must be above first value or one must be
                %above second.
minL=7;
global ThetaB ThetaE
if isempty(ThetaB)
    load('190212_LRThetas_NBins20.mat','ThetaB','ThetaE')    
end
%h=waitbar(0,'Splitting Trace');
for i=1:length(Data)
    %waitbar(i/max(used))
    I=used(i);
    [Splits,~,~,Fnew,Cnew]=FindBestMultiSplit_WH([Data(i).A],[Data(i).Hits],framegap,F1min,minL);
    if fxycS(I).frame(1)~=1
        offset=-1;
    else
        offset=0;
    end
    Splits(2:end)=Splits(2:end)+offset;
    fxycS(I).Splits=Splits;
    fxycS(I).split_goodness=Fnew;
    fxycS(I).split_class=Cnew;
end
%close(h)