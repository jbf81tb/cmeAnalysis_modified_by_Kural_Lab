function [BegPL,found]=LongTraceInitiationDetection(Ints,slopebound,R2Bound,endsize,background,backgroundSD)

beg=find(Ints,3,'first');
begInts=Ints(beg);
start=find(Ints==min(begInts));
for i1=start+3:length(Ints)
    clear TempInts x rsq
    for i2=start:i1
        TempInts(i2)=Ints(i2);
        x(i2)=i2;
    end
    [~,rsq]=LinearSlopeandR2(x,TempInts);
        rsqvect(i1)=rsq;
end
VeryGood=find(rsqvect>.9);
QuiteGood=find(rsqvect>.85);
Good=find(rsqvect>.8);
if ~isempty(VeryGood)
    finish=VeryGood(length(VeryGood));
else
    if ~isempty(QuiteGood)
        finish=QuiteGood(length(QuiteGood));
    else
        if ~isempty(Good)
            finish=Good(length(Good));
        else
            BegPL=[];
            found=false;
            return
        end
    end
end
clear y x
for i1=start:finish
    y(i1)=Ints(i1);
    x(i1)=i1;
end
[slope, intercept, rsq]=LinearSlopeInterceptandR2(x,y);
ValueAtStart=intercept+slope*start;
if finish-start>=10
    found=true;
if ValueAtStart<=background+backgroundSD
    BegPL=[start finish-start+1];
else
    BegPL=[];
end
end
if finish-start<10
BegPL=[];
found=false;
end
