clear all
load('FlyPlane2Threshfxyc175.mat');
%load('FlyEndsfxyc.mat');
neighborhood=40;
MoveTime=6; %number of frames a displacement is averaged over to determine direction of movement
[a,b,c]=size(Threshfxyc);
[d,e,~]=size(Threshfxyc);
%density=zeros(1,c);
h=waitbar(0,'Calculating Spot Density');
Group=3;
for i=1:c
    waitbar(i/c)
    slots=find(Threshfxyc(:,5,i));
    rsum=zeros(1,length(slots)); %vector to be used to calculate the average separation between spots in the neighborhood
    drsum=zeros(1,length(slots)); %"         "           "            "    " change in the separation between spots in the neighborhood (can be negative if spots are moving in)
    count=zeros(1,length(slots)); %not actually necessary for the calculation, but I kept it in case I can use it as a check later
    for j=1:length(slots)
        f=Threshfxyc(slots(j),1,i); %information about the single time point of the spot being observed (frame, xy position)
        x=Threshfxyc(slots(j),2,i);
        y=Threshfxyc(slots(j),3,i);
        %rsum(j)=0;
        %count(j)=0;
        %drsum(j)=0;
        for k=1:d
            framespots=find(Threshfxyc(k,1,:)==f); %find all spots in the same frame as the one being observed (must do this over all k's (hence the for loop))
            for l=1:length(framespots)
                dist=sqrt((x-Threshfxyc(k,2,framespots(l)))^2+(y-Threshfxyc(k,3,framespots(l)))^2);
                traced=find(Threshfxyc(:,1,framespots(l)));
                if dist<=neighborhood && dist>0 && length(traced)>=7 %limit spots to ones in neighborhood, but not the original spot and ones with long enough traces so that they can have reasonably acurate displacement values
                    rsum(j)=rsum(j)+dist;
                    count(j)=count(j)+1;
                    seq=find(traced==k);
                    if seq(1)<4
                        distf=sqrt((x-Threshfxyc(traced(7),2,framespots(l)))^2+(y-Threshfxyc(traced(7),3,framespots(l)))^2);
                        disti=sqrt((x-Threshfxyc(traced(1),2,framespots(l)))^2+(y-Threshfxyc(traced(1),3,framespots(l)))^2);
                    end
                    if seq(1)>length(traced)-3
                        distf=sqrt((x-Threshfxyc(traced(length(traced)),2,framespots(l)))^2+(y-Threshfxyc(traced(length(traced)),3,framespots(l)))^2);
                        disti=sqrt((x-Threshfxyc(traced(length(traced)-6),2,framespots(l)))^2+(y-Threshfxyc(traced(length(traced)-6),3,framespots(l)))^2);
                    end
                    if seq(1)>=4 && seq(1)<=length(traced)-3
                        distf=sqrt((x-Threshfxyc(traced(seq(1)+3),2,framespots(l)))^2+(y-Threshfxyc(traced(seq(1)+3),3,framespots(l)))^2);
                        disti=sqrt((x-Threshfxyc(traced(seq(1)-3),2,framespots(l)))^2+(y-Threshfxyc(traced(seq(1)-3),3,framespots(l)))^2);
                    end
                    drsum(j)=drsum(j)+(distf-disti); %change in distance between close spots (now weighted to favor information from long traces (because they're more likely to be accurate))
                end
            end
        end
        if count(j)~=0
            Strain(j)=drsum(j)/rsum(j);
        else
            Strain(j)=0;
        end
        Threshfxyc(slots(j),9,i)=Strain(j);
    end
    for j=1:floor(length(slots)/Group)
        sum=0;
        for k=1:Group
            sum=sum+Threshfxyc(slots((j-1)*Group+k),9,i);
        end
        for k=1:Group
            Threshfxyc(slots((j-1)*Group+k),9,i)=sum/Group;
        end
    end
end
save FlyPlane2Strainfxyc175N40Grouped.mat Threshfxyc
%ColorSpotsByStrain(Threshfxyc,'ExpansionStack400.tif','ExpansionStack400Strain300N40Grouped.tif')
close(h)