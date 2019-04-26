MF=max([fxycS.frame]);
events=FindFrameEventsFXYCS(fxycS,MF);
N=length(events(:,1));
clear fxycS2
fxycS2(N)=struct();
for i=1:N
    T=events(i,1);
    fxycS2(i).frame=[1 2];
    fxycS2(i).int=[fxycS(T).int(end) fxycS(T).int(end)];
    fxycS2(i).xpos=[fxycS(T).xpos(end) fxycS(T).xpos(end)];
    fxycS2(i).ypos=[fxycS(T).ypos(end) fxycS(T).ypos(end)];
    fxycS2(i).lt=2;
    fxycS2(i).class=fxycS(T).class;
end

%%
fxycScomb=CombineTraceStructs(fxycS,fxycS2,MF);