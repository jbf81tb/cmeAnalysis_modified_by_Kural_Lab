clear all
load('ColdblockShort_750_WTrackSplitting.mat');
cuts=[];
fxyc=Threshfxyc;
Thresh=750;
slopebound=0;
R2Bound=.5;
endsize=4;
background=1151;
backgroundSD=562;
i1=8385;
used=find(fxyc(:,1,i1));
    Ints=zeros(1,length(used));
    for i2=1:length(used)
        if fxyc(used(i2),5,i1)~=0
            Ints(i2)=fxyc(used(i2),5,i1);
        else
            Ints(i2)=Thresh;
        end
    end
    [BegPL,FinPL]=SplitEndDecisionLinearRegression(Ints,slopebound,R2Bound,endsize);
    for i2=1:length(FinPL)
        found=false; %If no next beginning is found, different procedure is used
        for i3=1:length(BegPL)
            if FinPL(i2)<BegPL(i3)
                subints=zeros(1,BegPL(i3)+endsize-FinPL(i2));
                for i4=FinPL(i2):BegPL(i3)+endsize-1 %Record intensities between the end and the next beginning
                    subints(i4-FinPL(i2)+1)=Ints(i4);
                end
                if min(subints)<=background+backgroundSD %If the min intensities in this range is low engough, cut the trace at the min (cuts are taken care of later)
                    cuts=[cuts find(subints==min(subints))+FinPL(i2)-1];
                end
                found=true;
                break %If the next beginning is found, don't need to look for another one
            end
        end
        if found==false
            for i3=FinPL(i2):length(Ints)
                if Ints(i3)<background %If the intensity ever goes below background with no start afterword, cut off the rest
                    cuts=[cuts i3];
                    break
                end
            end
        end
    end
    for i2=1:length(Ints)
        if Ints(i2)>background+backgroundSD %Look for part at the beginning that could be just noise
            BeginningCutoff=i2;
            break
        end
    end
    if BeginningCutoff>1 %Cut it off at the last time it goes below the background level
        belows1=find(Ints<background);
        for i2=1:BeginningCutoff-1
            belows2(i2)=i2;
        end
        belows=intersect(belows1,belows2);
        if ~isempty(belows)
            cuts=[cuts belows(length(belows))];
        end
    end
    %Use cuts to cut up fxyc appropriately
