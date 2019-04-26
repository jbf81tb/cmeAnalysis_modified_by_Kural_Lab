function fxyc=Track2fxyc(track)

ind=1;
U=sort(unique(track.f));
fxyc=zeros(length(U),5);
for i=U
    used=find(track.f==i);
    if ~isempty(used)
        fxyc(ind,:)=[track.f(used(1)) track.x(used(1)) track.y(used(1)) track.isCCP+3 track.A(used(1))];
        ind=ind+1;
    end
end
used=find(fxyc(:,1));
fxyc=fxyc(used,:);