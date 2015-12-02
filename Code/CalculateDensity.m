clear all
load('FlyThreshfxyc5.mat');
load('FlyEndsfxyc.mat');
neighborhood=10;
[a,b,c]=size(Endsfxyc);
[d,e,f]=size(Threshfxyc);
density=zeros(1,c);
h=waitbar(0,'Calculating Spot Density');
for i=1:c
    waitbar(i/c)
    density(i)=0;
    slots=find(Endsfxyc(:,5,i));
    for j=1:length(slots)
        f=Endsfxyc(slots(j),1,i);
        x=Endsfxyc(slots(j),2,i);
        y=Endsfxyc(slots(j),3,i);
        for k=1:d
            framespots=find(Threshfxyc(k,1,:)==f);
            for l=1:length(framespots)
                if sqrt((x-Threshfxyc(k,2,framespots(l)))^2+(y-Threshfxyc(k,3,framespots(l)))^2)<=neighborhood && sqrt((x-Threshfxyc(k,2,framespots(l)))^2+(y-Threshfxyc(k,3,framespots(l)))^2)>0
                    density(i)=density(i)+1;
                end
            end
        end
    end
    density(i)=density(i)/length(slots);
end
save Flydensity2.mat density
close(h)