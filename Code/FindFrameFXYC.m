clear Framefxyc
frame=99;
FrameSpots=zeros(length(fxyc(:,1,1)),length(fxyc(1,1,:)));
for j=1:length(fxyc(:,1,1))
FrameSpots(j,:)=[find(fxyc(j,1,:)==frame);zeros(length(fxyc(1,1,:))-length(find(fxyc(j,1,:)==frame)),1)];
end
index=1;
for j=1:length(fxyc(:,1,1))
    A=find(FrameSpots(j,:));
for i=1:length(A)
Framefxyc(index,:)=fxyc(j,:,FrameSpots(j,A(i)));
index=index+1;
end
end