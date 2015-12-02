[A,B,C]=size(Threshfxyc);
frames=max(max(Threshfxyc(:,1,:)));
totalfpos=[];
dimfpos=[];
totalfpos=zeros(A*C,3);
dimfpos=zeros(A*C,3);
indext=1;
indexd=1;
h=waitbar(0,'Finding Unique Spots');
for i=1:C
    waitbar(i/C)
    for i2=1:A
        if Threshfxyc(i2,4,i)==1 || Threshfxyc(i2,4,i)==2 || Threshfxyc(i2,4,i)==3 || Threshfxyc(i2,4,i)==8
            totalfpos(indext,:)=[Threshfxyc(i2,1,i) Threshfxyc(i2,2,i) Threshfxyc(i2,3,i)];
            indext=indext+1;
        end
        if Threshfxyc(i2,4,i)==8
            dimfpos(indexd,:)=[Threshfxyc(i2,1,i) Threshfxyc(i2,2,i) Threshfxyc(i2,3,i)];
            indexd=indexd+1;
        end
    end
end
close(h)
totalfpos=unique(totalfpos,'rows');
dimfpos=unique(dimfpos,'rows');
dim=zeros(frames,1);
total=zeros(frames,1);
for i=1:frames
    dim(i)=length(find(dimfpos(:,1)==i));
    total(i)=length(find(totalfpos(:,1)==i));
end
        
        