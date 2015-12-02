function mindist=CalculateInterframeNNDistance(PosMat1,PosMat2)
%PosMat has positions of all spots in the desired frame with (i,1) being
%the x coordinate of spot i, and (i,2) being the y coordinate

[a,~]=size(PosMat1);
[b,~]=size(PosMat2);
mindist=ones(1,a)*100;
for i1=1:a
    for i2=1:b
        dist=sqrt((PosMat1(i1,1)-PosMat2(i2,1))^2+(PosMat1(i1,2)-PosMat2(i2,2))^2);
        if dist<mindist(i1)
            mindist(i1)=dist;
        end
    end
end
