function [MaxDist,MaxDist2,MaxA,MaxA2,MaxHole]=FindTrackStats(Sfxyc)

inds=find(Sfxyc(:,2,1));
dist=zeros(1,length(inds)-1);
dist2=zeros(1,length(inds)-1);
AC2=zeros(1,length(inds)-1);
Hole=zeros(1,length(inds)-1);

for i=1:length(inds)-1
    dist(i)=sqrt((Sfxyc(i+1,2,1)-Sfxyc(i,2,1))^2+(Sfxyc(i+1,3,1)-Sfxyc(i,3,1))^2);
    AC(i)=exp(abs(log(Sfxyc(i+1,5,1)/Sfxyc(i,5,1))));
    if Sfxyc(i+1,7,1)~=Sfxyc(i,7,1)
      
        AC2(i)=AC(i);
        dist2(i)=dist(i);
    end
    if Sfxyc(i+1,1,1)~=Sfxyc(i,1,1)+1
        Hole(i)=Sfxyc(i+1,1,1)-Sfxyc(i,1,1)-1;
    end
end
MaxDist=max(dist);
MaxDist2=max(dist2);
MaxA=max(AC);
MaxA2=max(AC2);
MaxHole=max(Hole);

