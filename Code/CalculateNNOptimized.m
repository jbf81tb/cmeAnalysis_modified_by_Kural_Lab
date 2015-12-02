function fxyc=CalculateNNOptimized(fxyc) %Record average NN distance in 11th slot of fxyc

[~,~,a]=size(fxyc);
frames=max(max(fxyc(:,1,:)));
% h=waitbar(0,'Finding Nearest Neighbor Distances');
for i1=1:frames
%     waitbar(i1/frames)
    [indices,positions]=FindFramePositions(fxyc,i1);
    [b,~]=size(indices);
    for i2=1:b
        x=positions(i2,1);
        y=positions(i2,2);
        closest=100;
        for i3=1:b
            if i2~=i3
                x2=positions(i3,1);
                y2=positions(i3,2);
                dist=sqrt((x-x2)^2+(y-y2)^2);
                if dist<closest
                    closest=dist;
                end
            end
        end
        fxyc(indices(i2,1),11,indices(i2,2))=closest; %Record all single frame NN distances (to be averaged later)
    end
end
for i1=1:a
    used=find(fxyc(:,11,i1));
    NNvect=fxyc(used,11,i1);
    meanNN=mean(NNvect);
    for i2=1:length(used)
        fxyc(used(i2),11,i1)=meanNN;
    end
end
% close(h)