%path1=path3;
maxdist=1;
neighborhood=20;
load(path1)
fxyc1=Threshfxyc;
load(path2)
fxyc2=Threshfxyc;
[a11,~,a13]=size(fxyc1);
[a21,~,a23]=size(fxyc2);
frames=max(max(fxyc1(:,1,:)));
h=waitbar(0,'Looking for Trace Correspondences');
Excorrespondences=cell(a13,a23);
for i1=1:a13
    waitbar(i1/a13)
    used1=find(fxyc1(:,1,i1));
    span1=fxyc1(used1,1,i1);
    for i2=1:a23 %go through all pairs of traces, one from each plane and find corresponding parts
        used2=find(fxyc2(:,1,i2));
        span2=fxyc2(used2,1,i2);
        Ax1=fxyc1(used1(1),2,i1);
        Ay1=fxyc1(used1(1),3,i1);
        Ax2=fxyc2(used2(1),2,i2);
        Ay2=fxyc2(used2(1),3,i2);
        ApproxDist=sqrt((Ax1-Ax2)^2+(Ay1-Ay2)^2);
        if ~isempty(intersect(span1,span2)) && ApproxDist<=neighborhood
            for i3=1:length(used1) %Look for a correspondece for the point at fxyc1(used(i3),:,i1)
                match=find(fxyc2(:,1,i2)==fxyc1(used1(i3),1,i1));
                if ~isempty(match)
                    dist=sqrt((fxyc1(used1(i3),2,i1)-fxyc2(match(1),2,i2))^2+(fxyc1(used1(i3),3,i1)-fxyc2(match(1),3,i2))^2);
                    if dist<=maxdist
                        Excorrespondences{i1,i2}=[Excorrespondences{i1,i2} fxyc1(used1(i3),1,i1)];
                    end
                end
            end
        end
    end
end
save FlyExCorrespondences32_175_New.mat Excorrespondences
close(h)