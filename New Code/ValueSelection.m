results=[];
lifetime=[];
frames=max(max(Threshfxyc(:,1,:)));
EByFrame=zeros(1,frames);
LByFrame=zeros(1,frames);
NByFrame=zeros(1,frames);
MeanEByFrame=zeros(1,frames);
indices=zeros(1,frames);
h=waitbar(0,'Indexing Eccentricity Data by Frame');
for i=1:length(Threshfxyc(1,1,:))
    waitbar(i/length(Threshfxyc(1,1,:)))
    usede=find(Threshfxyc(:,10,i)>0);
    usedr=find(Threshfxyc(:,9,i)>=.8);
    used=intersect(usede,usedr);
    if ~isempty(used) && length(used)>=10 && Threshfxyc(1,4,i)>0 && Threshfxyc(1,4,i)<4
    rs=Threshfxyc(used,10,i);
    sorted=sort(rs);
    wanted=find(sorted,5,'last');
    maxrs=sorted(wanted);
    results=[results mean(maxrs)];
    lifetime=[lifetime length(usede)];
    for j=1:length(usede)
        EByFrame(Threshfxyc(usede(j),1,i))=EByFrame(Threshfxyc(usede(j),1,i))+mean(maxrs);
        LByFrame(Threshfxyc(usede(j),1,i))=LByFrame(Threshfxyc(usede(j),1,i))+length(usede);
        NByFrame(Threshfxyc(usede(j),1,i))=NByFrame(Threshfxyc(usede(j),1,i))+1;
        indices(Threshfxyc(usede(j),1,i))=indices(Threshfxyc(usede(j),1,i))+1;
        Es(Threshfxyc(usede(j),1,i),indices(Threshfxyc(usede(j),1,i)))=mean(maxrs);
    end
    end
end
close(h)
for i=1:frames
MeanEByFrame(i)=EByFrame(i)/NByFrame(i);
MeanLByFrame(i)=LByFrame(i)/NByFrame(i);
end