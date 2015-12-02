[a,b]=size(TraceX);
for i=1:a
    if length(find(TraceX(i,:),1,'first'))>0
starts(i)=find(TraceX(i,:),1,'first');
finishes(i)=find(TraceX(i,:),1,'last');

    Xstart(i)=TraceX(i,starts(i));
    Ystart(i)=TraceY(i,starts(i));
    Xfinish(i)=TraceX(i,finishes(i));
    Yfinish(i)=TraceY(i,finishes(i));
    end
end