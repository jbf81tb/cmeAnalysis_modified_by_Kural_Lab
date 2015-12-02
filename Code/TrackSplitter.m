function fxyc=TrackSplitter(fxyc,Thresh,slopebound,R2Bound,endsize,background,backgroundSD) %background is the average of all the first frame intensities

[a,b,c]=size(fxyc);

for i1=1:c
    cuts=[];
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
                PossibleCutoff=find(Ints==min(subints));
                PCutoffFix=PossibleCutoff(1);
                SubintsPrev=zeros(1,PCutoffFix);
                SubintsAft=zeros(1,length(Ints)-PCutoffFix+1);
                for i4=1:PCutoffFix
                    SubintsPrev(i4)=Ints(i4);
                end
                for i4=PCutoffFix:length(Ints)
                    SubintsAft(i4-PCutoffFix+1)=Ints(i4);
                end
                if min(subints)<=background+.5*backgroundSD && min(subints)<=min(2*max(SubintsPrev),2*max(SubintsAft)) %If the min intensities in this range is low engough, cut the trace at the min (cuts are taken care of later)
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
                end
            end
        end
    end
    BeginningCutoff=0;
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
    EndCutoff=length(Ints);
    for i2=1:length(Ints)
        if Ints(length(Ints)+1-i2)>background+backgroundSD %Look for part at the beginning that could be just noise
            EndCutoff=length(Ints)+1-i2;
            break
        end
    end
    if EndCutoff<length(Ints) %Cut it off at the last time it goes below the background level
        belows1=find(Ints<background);
        for i2=EndCutoff+1:length(Ints)
            belows2(i2)=i2;
        end
        belows=intersect(belows1,belows2);
        if ~isempty(belows)
            cuts=[cuts belows(1)];
        end
    end
    TempIndex1=1;
    TempIndex2=1;
    tempfxyc=[];
    for i2=1:length(used)%Use cuts to cut up fxyc appropriately--The point on the cut gets put in both parts
        if ~ismember(i2,cuts)
            tempfxyc(TempIndex1,:,TempIndex2)=fxyc(used(i2),:,i1);
            TempIndex1=TempIndex1+1;
        else
            tempfxyc(TempIndex1,:,TempIndex2)=fxyc(used(i2),:,i1);
            TempIndex1=1;
            TempIndex2=TempIndex2+1;
            tempfxyc(TempIndex1,:,TempIndex2)=fxyc(used(i2),:,i1);
            TempIndex1=TempIndex1+1;
        end
    end
    [ta,tb,tc]=size(tempfxyc);
    for i2=1:a
        for i3=1:b %erase old fxyc data
            fxyc(i2,i3,i1)=0;
        end
    end
    for i2=1:tc %Copy data from tempfxyc to the real fxyc
        if i2==1 %the first trace gets put where the original was
            for i3=1:ta
                for i4=1:tb
                    fxyc(i3,i4,i1)=tempfxyc(i3,i4,i2);
                end
            end
        else
            c=c+1; %subsequent traces get put on the end
            for i3=1:ta
                for i4=1:tb
                    fxyc(i3,i4,c)=tempfxyc(i3,i4,i2);
                end
            end
        end
    end
end