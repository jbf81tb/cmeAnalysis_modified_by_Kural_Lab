clear all
load('Expansion2NThreshfxyc150.mat');
%load('FlyEndsfxyc.mat');
neighborhood=25;
%[a,b,c]=size(Endsfxyc);
[d,e,f]=size(Threshfxyc);
%density=zeros(1,c);
wait=waitbar(0,'Calculating Spot Densities');
for in=1:f
    waitbar(in/f)
    
    slots=find(Threshfxyc(:,5,in));
    for j=1:length(slots)
        density=0;
        frame=Threshfxyc(slots(j),1,in);
        x=Threshfxyc(slots(j),2,in);
        y=Threshfxyc(slots(j),3,in);
        for k=1:d
            framespots=find(Threshfxyc(k,1,:)==frame);
            for l=1:length(framespots)
                if sqrt((x-Threshfxyc(k,2,framespots(l)))^2+(y-Threshfxyc(k,3,framespots(l)))^2)<=neighborhood && sqrt((x-Threshfxyc(k,2,framespots(l)))^2+(y-Threshfxyc(k,3,framespots(l)))^2)>0
                    density=density+1;
                end
            end
        end
        Threshfxyc(slots(j),8,in)=density;
    end
    
end
save Expansion2Ndensityfxyc.mat Threshfxyc
close(wait)