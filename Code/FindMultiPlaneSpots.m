function FoundSpotsMP=FindMultiPlaneSpots(path1,path2,path3)

maxdist=2;
load(path1)
FoundSpots1=FoundSpots;
load(path2)
FoundSpots2=FoundSpots;
load(path3)
FoundSpots3=FoundSpots;
frames=max(FoundSpots(:,1));
FoundSpotsMP=[];
h=waitbar(0,'Finding Colocalizations');
for i1=1:frames
    waitbar(i1/frames)
    inds1=find(FoundSpots1(:,1)==i1);
    inds2=find(FoundSpots2(:,1)==i1);
    inds3=find(FoundSpots3(:,1)==i1);
    for i2=1:length(inds2)
        x2=FoundSpots2(inds2(i2),2);
        y2=FoundSpots2(inds2(i2),3);
        found=false;
        for i3=1:length(inds1)
            x1=FoundSpots1(inds1(i3),2);
            y1=FoundSpots1(inds1(i3),3);
            dist=sqrt((x1-x2)^2+(y1-y2)^2);
            if dist<=maxdist
                found=true;
                break
            end
        end
        if found==true
        else
            for i3=1:length(inds3)
                x1=FoundSpots3(inds3(i3),2);
                y1=FoundSpots3(inds3(i3),3);
                dist=sqrt((x1-x2)^2+(y1-y2)^2);
                if dist<=maxdist
                    found=true;
                    break
                end
            end
        end
        if found==true
            FoundSpotsMP=[FoundSpotsMP;[i1 x2 y2 FoundSpots2(inds2(i2),4)]];
        end
    end
end
close(h)