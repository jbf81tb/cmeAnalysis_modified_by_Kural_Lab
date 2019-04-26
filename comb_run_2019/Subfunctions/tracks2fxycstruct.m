function fxycS=tracks2fxycstruct(tracks)

N=length(tracks);
if N==0
    fxycS=struct([]);
    return
end
fxycS(N)=struct();
for i0=1:length(tracks)
    track=tracks(i0);
    U=sort(unique(track.f));
    U=U(~isnan(U));
    L=length(U);
    fxycS(i0).frame=zeros(1,L);
    fxycS(i0).int=zeros(1,L);
    fxycS(i0).xpos=zeros(1,L);
    fxycS(i0).ypos=zeros(1,L);
    fxycS(i0).class=track.isCCP+3;
    fxycS(i0).lt=U(end)-U(1);
    ind=1;
    for i=U
        used=find(track.f==i);
        if ~isempty(used)
            fxycS(i0).frame(ind)=i;
            fxycS(i0).int(ind)=track.A(used(1));
            fxycS(i0).xpos(ind)=track.x(used(1));
            fxycS(i0).ypos(ind)=track.y(used(1));
            ind=ind+1;
        end
    end
    if ind~=L+1
        used=find(fxycS(i0).frame);
        fxycS(i0).frame=fxycS(i0).frame(used);
        fxycS(i0).int=fxycS(i0).int(used);
        fxycS(i0).xpos=fxycS(i0).xpos(used);
        fxycS(i0).ypos=fxycS(i0).ypos(used);
    end
    fxycS(i0).frame=single(fxycS(i0).frame);
    fxycS(i0).int=single(fxycS(i0).int);
    fxycS(i0).xpos=single(fxycS(i0).xpos);
    fxycS(i0).ypos=single(fxycS(i0).ypos);
end