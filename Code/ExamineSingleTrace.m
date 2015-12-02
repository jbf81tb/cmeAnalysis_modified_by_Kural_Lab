clear all
path='FlyFullfxyc4.mat';
file='FlyStack2TAv.tif'; %File to trace on
newfile='Fly2Track';
load(path);
Thresh=200;
done=false;
index=1;
for i=1:100
    clear Sfxyc TraceINT
    newfile='Fly3Track';
track=ChooseRandomInterestingTrack(fxyc,Thresh);
endsize=2;
fade=.75;
newfile=strcat(newfile,num2str(track),'.tif');
Sfxyc(:,:,1)=fxyc(:,:,track);
TraceINT(1,:)=Sfxyc(:,5,1);
clear firstint lastint ints
i=1;
fi=find(TraceINT(i,:));
inds=fi;
maxi=find(TraceINT(i,:)==max(TraceINT(i,:)));
maxii=find(fi==maxi(1));
if length(fi)>=3
    if maxii~=1 && maxii~=length(fi) && length(inds)>8
        maxis=[fi(maxii-1) fi(maxii+1)];
    else
        if maxii==1
            maxis=[fi(1) fi(2) fi(3)];
        end
        if maxii==length(fi)
            maxis=[fi(length(fi)-2) fi(length(fi)-1) fi(length(fi))];
        end
    end
end
if length(inds)<=6 || length(fi)<3
    maxis=[fi(maxii) fi(maxii) fi(maxii)];
end

for j=1:length(maxis)
    maxints(j)=TraceINT(i,maxis(j));
end
for j=1:length(fi)
    ints(j)=TraceINT(i,fi(j));
end
firsts=find(TraceINT(i,:),endsize,'first');
lasts=find(TraceINT(i,:),endsize,'last');
for j=1:length(firsts)
    firstint(j)=TraceINT(i,firsts(j));
end
for j=1:length(lasts)
    lastint(j)=TraceINT(i,lasts(j));
end
beginning=mean(firstint);
middle=mean(maxints);
finish=mean(lastint);
ends=0;
if beginning<middle*fade && middle>=0 %middle clause not important with new threshlod
    ends=1;
end
if  middle>=0 && finish<middle*fade %clause to make sure the end isn't cut off by the end of the movie
    ends=ends+2;
end
[MaxDist,MaxDist2,MaxA,MaxA2,MaxHole]=FindTrackStats(Sfxyc);
ColorSpots(Sfxyc,file,newfile);
Results(index,1)=track;
Results(index,2)=ends;
Results(index,3)=MaxDist;
Results(index,4)=MaxDist2;
Results(index,5)=MaxA;
Results(index,6)=MaxA2;
Results(index,7)=MaxHole;
Results(index,8)=beginning;
Results(index,9)=middle;
Results(index,10)=finish;
Results(index,11)=length(fi);
index=index+1
save Results3.mat Results
end