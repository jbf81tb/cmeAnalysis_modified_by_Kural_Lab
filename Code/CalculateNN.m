function fxyc=CalculateNN(fxyc) %Finds average distance to nearest neighbor over the trace which can be used to set max distance in traces to be connected
%Saves number to slot 11
[a,b,c]=size(fxyc);
waitbar(0,'Finding Nearest Neighbor Distances');
for i1=1:c
    waitbar(i1/c)
    used=find(fxyc(:,1,i1));
    near=zeros(1,length(used));
    for i2=1:length(used)
        x=fxyc(used(i2),2,i1);
        y=fxyc(used(i2),3,i1);
        f=fxyc(used(i2),1,i1);
        closest=100; %Starter value, will be overwritten when a closer pit is found
        for i3=1:c
            if i3~=i1
                sameframe=find(fxyc(:,1,i3)==f);
                if ~isempty(sameframe)
                    x2=fxyc(sameframe,2,i3);
                    y2=fxyc(sameframe,3,i3);
                    dist=sqrt((x-x2)^2+(y-y2)^2);
                    if dist<closest
                        closest=dist;
                    end
                end
            end
        end
        near(i2)=closest;
    end
    meannear=mean(nonzeros(near));
    for i2=1:length(used)
        fxyc(used(i2),11,i1)=meannear;
    end
end
close(h)
        
    