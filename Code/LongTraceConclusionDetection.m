function [FinPL,found]=LongTraceConclusionDetection(Ints,slopebound,R2Bound,endsize,background,backgroundSD)

fin=find(Ints,3,'last');
finInts=Ints(fin);
finish=find(Ints==min(finInts));
for i1=1:finish-3
    clear TempInts x rsq
    for i2=i1:finish
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
    start=VeryGood(1);
else
    if ~isempty(QuiteGood)
       start=QuiteGood(1);
    else
        if ~isempty(Good)
            start=Good(1);
        else
            FinPL=[];
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
ValueAtFinish=intercept+slope*finish;
if finish-start>=10
    found=true;
if ValueAtFinish<=background+backgroundSD
    FinPL=[finish finish-start+1];
else
    FinPL=[];
end
end
if finish-start<10
    found=false;
if ValueAtFinish<=background+2*backgroundSD
    FinPL=[finish finish-start+1];
else
    FinPL=[];
end
end