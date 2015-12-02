FrameSpots=find(fxyc(:,1)==1);
index=1;
for i=1:length(FrameSpots)
Framefxyc(index,:)=fxyc(FrameSpots(i),:);
index=index+1;
end