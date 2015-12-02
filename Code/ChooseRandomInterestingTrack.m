function track=ChooseRandomInterestingTrack(fxyc)
%chooses a track that has legit ends according to current criteria for
%examination
%Currently selects traces w maxint>Thresh
for i=1:length(fxyc(1,1,:))
    MaxInt(i)=max(fxyc(:,5,i));
    NFrames(i)=length(find(fxyc(:,1,i)));
end
ITracks1=find(fxyc(1,4,:)>=3);
ITracks2=find(fxyc(1,4,:)<=3);
ITracks3=find(fxyc(1,1,:)>=450);
%ITracks4=find(NFrames>=50);
ITracksa=intersect(ITracks1,ITracks2);
ITracks=intersect(ITracksa,ITracks3);
%ITracks=intersect(ITracks,ITracks4);
track=ITracks(ceil(rand*length(ITracks)));