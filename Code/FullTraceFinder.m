[TraceNum,~]=size(BigX);
for i=1:TraceNum
    candidates(i)=i;
end
start=[0 35];
finish=[72 0];
Xi=[215 224]; %217
Xf=[0 0];
Yi=[176 184]; %183
Yf=[0 0];
if finish(1)~=0
    candidates=intersect(candidates,find(finishes>=finish(1)));
end
if finish(2)~=0
    candidates=intersect(candidates,find(finishes<=finish(2)));
end
if start(1)~=0
    candidates=intersect(candidates,find(starts>=start(1)));
end
if start(2)~=0
    candidates=intersect(candidates,find(starts<=start(2)));
end
if Xi(1)~=0
    candidates=intersect(candidates,find(Xstart>=Xi(1)));
end
if Xi(2)~=0
    candidates=intersect(candidates,find(Xstart<=Xi(2)));
end
if Xf(1)~=0
    candidates=intersect(candidates,find(Xfinish>=Xf(1)));
end
if Xf(2)~=0
    candidates=intersect(candidates,find(Xfinish<=Xf(2)));
end
if Yi(1)~=0
    candidates=intersect(candidates,find(Ystart>=Yi(1)));
end
if Yi(2)~=0
    candidates=intersect(candidates,find(Ystart<=Yi(2)));
end
if Yf(1)~=0
    candidates=intersect(candidates,find(Yfinish>=Yf(1)));
end
if Yf(2)~=0
    candidates=intersect(candidates,find(Yfinish<=Yf(2)));
end
candidates