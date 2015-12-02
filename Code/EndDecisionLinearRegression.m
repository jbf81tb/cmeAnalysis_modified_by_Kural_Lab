function [BegPL,FinPL]=EndDecisionLinearRegression(Ints,slopebound,R2Bound,endsize,background,backgroundSD) %Give it a vector of the intensity data, it determines whether there are true beginning or end events, and tells you the position and length of the events
%Only give it vectors at least endsize points long
%NN is a 1x4 vector with the distance to the closest spot in the 4 frames surrounding the trace (entries are in chronological order 
BegPL=[];
FinPL=[];
a=length(Ints);
if a<endsize
    return
end
sorted=sort(Ints);
if length(Ints)>1
SecondMax=sorted(length(sorted)-1);
else
    SecondMax=max(Ints);
end
if SecondMax>=background+backgroundSD %Use second to maximum intensity to determine if trace is bright enough to prevent single outliers from interfering
    MaxInd=find(Ints==max(Ints),1,'first');
for i=1:a-endsize+1 %search for stretches where the intensity increases almost monotonically for at least 6 time points
    endints=zeros(1,endsize);
    for j=1:endsize
        endints(j)=Ints(i+j-1);
        x(j)=j;
    end
    [slope, rsq]=LinearSlopeandR2(x,endints);
    if slope>=slopebound && rsq>=R2Bound && i<MaxInd
        BegPL=[BegPL;[i rsq]];
    end
    if slope<=-1*slopebound && rsq>=R2Bound && i+endsize-1>MaxInd
        FinPL=[FinPL;[i rsq]];
    end
end
end