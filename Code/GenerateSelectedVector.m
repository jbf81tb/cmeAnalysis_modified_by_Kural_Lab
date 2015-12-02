function [Threshfxyc,Selected,MeanInts,MaxInts]=GenerateSelectedVector(Threshfxyc,MeanMin,MeanMax,MaxMin,MaxMax) %Changes Selected traces to c=8
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
    if MeanInt<MeanMax && MeanInt>MeanMin && MaxInt<MaxMax && MaxInt>MaxMin && (MeanDist>5 && MeanDist2>5)
        Selected=[Selected i];
        MeanInts=[MeanInts MeanInt];
        MaxInts=[MaxInts MaxInt];
        for i2=1:length(used)
            Threshfxyc(used(i2),4,i)=8;
        end
    end
end
    