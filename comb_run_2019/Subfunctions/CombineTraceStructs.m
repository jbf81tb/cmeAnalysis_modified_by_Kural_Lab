function fxycS1=CombineTraceStructs(fxycS1,fxycS2,FirstFrameS2)

%Find instances of tracks traces that exist in the overlap frame
events1=FindFrameEventsFXYCS(fxycS1,FirstFrameS2);
events2=FindFrameEventsFXYCS(fxycS2,1);
ToAdd=zeros(1,length(fxycS2));  %Keep track of which traces we need to add, so that we can add them all at once

if isempty(fxycS2)
    return
end
if isempty(fxycS1)
    for i=1:length(fxycS2)
        fxyc=fxycS2(i);
        fxyc.frame=fxyc.frame+FirstFrameS2-1;
        fxycS2(i)=fxyc;
    end
    fxycS1=fxycS2;
    return
end

for i=1:length(fxycS2)
    used=find(events2(:,1)==i);
    if isempty(used) %Doesn't start at beginning of movie
        ToAdd(i)=1;
    else  %Starts at beginning of movie--possibly a Continued Trace
        if fxycS2(i).lt==1 
            continue; 
        end
        x=events2(used(1),2);
        y=events2(used(1),3);
        used1=find(events1(:,2)==x & events1(:,3)==y);
        if isempty(used1) %New Trace
            ToAdd(i)=1;
        else %Continued Trace
            T=events1(used1(1),1);
            F=fxycS2(i).frame(2:end)+FirstFrameS2-1;
            fxycS1(T).frame=[fxycS1(T).frame F];
            fxycS1(T).int=[fxycS1(T).int fxycS2(i).int(2:end)];
            fxycS1(T).xpos=[fxycS1(T).xpos fxycS2(i).xpos(2:end)];
            fxycS1(T).ypos=[fxycS1(T).ypos fxycS2(i).ypos(2:end)];
            fxycS1(T).lt=fxycS1(T).frame(end)-fxycS1(T).frame(1);
        end
    end
end
ind=length(fxycS1)+1;
if sum(ToAdd)>0
    fxycS1(length(fxycS1)+sum(ToAdd)).frame=[]; %Initialize rest of struct
end
for i=1:length(fxycS2)
    if ToAdd(i)
        fxyc=fxycS2(i);
        fxyc.frame=fxyc.frame+FirstFrameS2-1;
        fxycS1(ind)=fxyc;
        ind=ind+1;
    end
end

