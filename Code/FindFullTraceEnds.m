[a,b]=size(BigX);
starts=zeros(1,a);
finishes=zeros(1,a);
for i=1:a
    if ~isempty(nonzeros(BigF(i,:)))
    starts(i)=min(nonzeros(BigF(i,:)));
    finishes(i)=max(BigF(i,:));
    Istart=find(BigF(i,:)==starts(i));
    Ifinish=find(BigF(i,:)==finishes(i));
    Xstart(i)=BigX(i,Istart(1));
    Ystart(i)=BigY(i,Istart(1));
    Xfinish(i)=BigX(i,Ifinish(1));
    Yfinish(i)=BigY(i,Ifinish(1));
    end
end