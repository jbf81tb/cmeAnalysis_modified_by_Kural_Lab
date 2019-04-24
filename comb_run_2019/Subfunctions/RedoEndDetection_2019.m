function fxyc=RedoEndDetection_2019(fxyc,movie,framegap)
%Store ML cat in fxyc(:,6,:)
%Store ML F1 in fxyc(:,7,:)


[C,B,E,F1]=ClassifyTraces_WHit(fxyc,movie,framegap);
N=length(fxyc(1,1,:));
for i=1:N
    used=find(fxyc(:,1,i));
    for i2=1:length(used)
        fxyc(used(i2),6,i)=C(i);
        fxyc(used(i2),7,i)=F1(i);
    end
end