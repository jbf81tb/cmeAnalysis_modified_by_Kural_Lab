function PosMat=MakePosMat(fxyc,frame)
%Makes matrix of spot positions in the desired frame

[a,~,b]=size(fxyc);
PosMat=[];
for i1=1:a
    for i3=1:b
        if fxyc(i1,1,i3)==frame
            PosMat=[PosMat;[fxyc(i1,2,i3) fxyc(i1,3,i3)]];
        end
    end
end