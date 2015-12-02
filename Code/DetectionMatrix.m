path='FlyFullfxyc4.mat';
file='FlyStack2TAv.tif'; %File to trace on
load(path);
[a,~,~]=size(fxyc);
Thresh=0;
index=1;
for frame=1:30
    A=imread(file,'Index',frame);
    [b,c]=size(A);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    inds=[];
    for i=1:a
    ind=find(fxyc(i,1,:)==frame);
    for j=1:length(ind)
        inds=[inds; [i ind(j)]];
    end
    end
    bright=max(max(A));
    [L,~]=size(inds);
    Bim=zeros(b,c);
    for j=1:L
        if fxyc(inds(j,1),5,inds(j,2))>=Thresh
        x=fxyc(inds(j,1),2,inds(j,2));
        y=fxyc(inds(j,1),3,inds(j,2));
        Bim(y,x)=1;
        singles=bwboundaries(Bim(:,:),'noholes');
        end
    end
    for i=1:length(singles)
        y=singles{i,1}(1,1);
        x=singles{i,1}(1,2);
        MAT(index+1,1)=frame;
        MAT(index+1,2)=x;
        MAT(index+1,3)=y;
        index=index+1;
    end
    
    
    %colormap(gray);
    %maximum=65535;
    %C=B*(maximum/bright);
    %image(C);
end