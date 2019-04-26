function events=FindFrameEventsFXYCS(fxycS,frame)

used1=zeros(1,length(fxycS));
for i=1:length(fxycS)
    if ismember(frame,fxycS(i).frame)
        used1(i)=1;
    end
end
events=zeros(sum(used1),3);
ind=1;
for i=1:length(fxycS)
    if used1(i)
        u=find(fxycS(i).frame==frame);
        events(ind,:)=[i fxycS(i).xpos(u(1)) fxycS(i).ypos(u(1))];
        ind=ind+1;
    end
end