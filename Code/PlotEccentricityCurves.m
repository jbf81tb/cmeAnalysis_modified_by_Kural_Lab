tracks=zeros(1,25);
minifxyc=zeros(313,13,25);
for i=1:25
tracks(i)=ChooseRandomInterestingTrack(Threshfxyc);
minifxyc(:,:,i)=Threshfxyc(:,:,tracks(i));
end
minifxyc=CalculateEccentricities(movie,minifxyc);
for i=1:25
results=[];
for j=1:length(minifxyc(:,1))
    if minifxyc(j,5,i)>=2000
        results=[results minifxyc(j,10,i)];
    end
end
subplot(5,5,i);
plot(results);
end