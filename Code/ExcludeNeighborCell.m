function [Threshfxyc]=ExcludeNeighborCell(Threshfxyc) %Changes Selected traces to c=8
Selected=[];
MeanInts=[];
MaxInts=[];
for i=1:length(Threshfxyc(1,1,:))
    used=find(Threshfxyc(:,1,i));
    Ints=Threshfxyc(used,5,i);
    Dists=Threshfxyc(used,6,i);
    MeanDist=mean(Dists);
    Dists2=Threshfxyc(used,7,i);
    MeanDist2=mean(Dists2);
    MeanInt=mean(Ints);
    MaxInt=max(Ints);
    if MeanDist2<=5 && used(length(used))<190 %Specific to coldblockshort
        Selected=[Selected i];
        MeanInts=[MeanInts MeanInt];
        MaxInts=[MaxInts MaxInt];
        for i2=1:length(used)
            Threshfxyc(used(i2),4,i)=4;
        end
    end
end