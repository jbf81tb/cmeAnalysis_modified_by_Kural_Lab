[a,b,c]=size(Threshfxyc);
index=1;
for i1=1:c
    inds=find(Threshfxyc(:,1,i1));
    for i2=1:length(inds)
        cint=Threshfxyc(inds(i2),5,i1);
        mint=Threshfxyc(inds(i2),8,i1);
        if mint~=0 && cint~=0
        ratio(index)=cint/mint;
        index=index+1;
        end
    end
end