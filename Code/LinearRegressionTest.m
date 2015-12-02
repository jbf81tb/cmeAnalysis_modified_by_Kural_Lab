clear all;
load('ColdblockShortfxyc_1000_Mint.mat');
Threshfxyc=fxyc;
[~,~,A]=size(Threshfxyc);
slopesYrsqB=[];
slopesYrsqE=[];
for i1=1:A
    used=find(Threshfxyc(:,1,i1));
    if length(used)>=8;
        ints=zeros(1,6);
        frames=zeros(1,6);
        for i2=1:6 %Find beginning intensity curve
            usedB=find(Threshfxyc(:,1,i1),6,'first');
            ints(i2)=Threshfxyc(usedB(i2),5,i1);
            frames(i2)=Threshfxyc(usedB(i2),1,i1);
            [slopeB, rsqB]=LinearSlopeandR2(frames,ints);
        end
        ints=zeros(1,6);
        frames=zeros(1,6);
        for i2=1:6 %Find end intensity curve
            usedE=find(Threshfxyc(:,1,i1),6,'last');
            ints(i2)=Threshfxyc(usedE(i2),5,i1);
            frames(i2)=Threshfxyc(usedE(i2),1,i1);
            [slopeE, rsqE]=LinearSlopeandR2(frames,ints);
        end
        slopesYrsqB=[slopesYrsqB;[slopeB rsqB]];
        slopesYrsqE=[slopesYrsqE;[slopeE rsqE]];
    end
end