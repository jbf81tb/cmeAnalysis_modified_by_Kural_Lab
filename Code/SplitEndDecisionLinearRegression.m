function [BegPL,FinPL]=SplitEndDecisionLinearRegression(Ints,slopebound,R2Bound,endsize) %Give it a vector of the intensity data, it determines whether there are true beginning or end events, and tells you the position and length of the events
%Only give it vectors at least endsize points long

BegPL=[];
FinPL=[];
a=length(Ints);
if a<endsize
    return
end
if max(Ints)>=2*min(Ints)
    MaxInd=find(Ints==max(Ints));
for i=1:a-endsize+1 %search for stretches where the intensity increases almost monotonically for at least 6 time points
    endints=zeros(1,endsize);
    for j=1:endsize
        endints(j)=Ints(i+j-1);
        x(j)=j;
    end
    [slope, rsq]=LinearSlopeandR2(x,endints);
    if slope>=slopebound && rsq>=R2Bound
        BegPL=[BegPL;[i]];
    end
    if slope<=-1*slopebound && rsq>=R2Bound
        FinPL=[FinPL;[i]];
    end
end
end