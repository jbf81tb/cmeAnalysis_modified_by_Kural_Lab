function fxyc2=AddSorted(frame,x1,y1,Int,fxyc2,i2)

[A,B,~]=size(fxyc2);
used=find(fxyc2(:,1,i2));
frames=zeros(1,length(used+1));
frames(1)=frame;
index=2;
Newfxyc=zeros(A,B);
for i=1:length(used)
    frames(index)=fxyc2(used(i),1,i2);
    index=index+1;
end
Sframes=sort(frames);
for i=1:length(Sframes)
    if Sframes(i)==frame
        Newfxyc(i,1)=frame;
        Newfxyc(i,2)=x1;
        Newfxyc(i,3)=y1;
        Newfxyc(i,8)=Int;
    else
        entry=find(fxyc2(:,1,i2)==Sframes(i));
        Newfxyc(i,:)=fxyc2(entry(1),:,i2);
    end 
end
[A,B]=size(Newfxyc);
for i=1:A
    for j=1:B
        fxyc2(i,j,i2)=Newfxyc(i,j);
    end
end
