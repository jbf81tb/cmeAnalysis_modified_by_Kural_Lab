function [mindist,AVmindist]=CalculateTotalInterframeNNDistance(path1,path2)
%Determines the average minimum distance between a spot in path1 and the
%closest spot in the corresponding frame of path2
load(path1);
Threshfxyc1=Threshfxyc;
frames1=max(max(Threshfxyc1(:,1,:)));
load(path2);
Threshfxyc2=Threshfxyc;
frames2=max(max(Threshfxyc2(:,1,:)));
mindist=[];
for i=1:min(frames1,frames2)
    
        PosMat1=MakePosMat(Threshfxyc1,i);
        PosMat2=MakePosMat(Threshfxyc2,i);
        mindist=[mindist mean(CalculateInterframeNNDistance(PosMat1,PosMat2))];
    
end
AVmindist=mean(mindist);