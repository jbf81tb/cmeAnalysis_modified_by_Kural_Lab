function Threshfxyc=FindDistanceToEdge(Threshfxyc,Bx,By,slot) %The dimensions are specialized to the Coldblock movie %This doesn't count the part of the boundary that is on the edge of the movie
%Saves min distance to Threshfxyc slot 6
[~,~,C]=size(Threshfxyc);
h=waitbar(0,'Finding Distances to Edge');
for i1=1:C
    waitbar(i1/C)
    used=find(Threshfxyc(:,1,i1));
    for i2=1:length(used)
        frame=Threshfxyc(used(i2),1,i1);
        x1=Threshfxyc(used(i2),2,i1);
        y1=Threshfxyc(used(i2),3,i1);
        mindist=400;
        bx=Bx{1,frame};
        by=By{1,frame};
        for i3=1:length(bx)
            x2=bx(i3);
            y2=by(i3);
            dist=sqrt((x1-x2)^2+(y1-y2)^2);
            if dist<mindist && x2<375 && y2<285 && x2>3 && y2>3 %Cut out the sides that aren't on the edges of the cell (Specific to ColdblockShort)
                mindist=dist;
            end
        end
        Threshfxyc(used(i2),slot,i1)=mindist; %Cell boundries are stored to 6, Crop boundries to 7
    end
end
close(h)

