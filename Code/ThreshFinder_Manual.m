clear all;
clear all;
%This program finds the value of Thresh you should use in TrackWrapper
%When you run it, pick a Thresh value (on the order of 100), it will show
%which spots are above that value.  Keep trying values until you're
%satisfied with the results

%Parameters that need to be set
path='FlyECropP2fxycMHZ_Simple.mat'; %The file that you saved the traces to in the first run of TrackWrapper
file='FlyECropP2.tif'; %File to trace on
fxyc=[];
load(path);
done=false;
[a1,~,a2]=size(fxyc);
frame=30;
while done==false
    Thresh=input('Thresh= (0 to quit) ');
    close
    if Thresh==0
        break
    end
    A=imread(file,'Index',frame);
    [b,c]=size(A);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    inds=[];
    for i=1:a1
        ind=find(fxyc(i,1,:)==frame);
        for i2=1:length(ind)
            inds=[inds;[i ind(i2)]];
        end
    end
    bright=max(max(A))/1.25;
    [L,~]=size(inds);
    Bim=zeros(b,c);
    singles=[];
    for j=1:L
        if fxyc(inds(j,1),8,inds(j,2))>=Thresh
            x=floor(fxyc(inds(j,1),2,inds(j,2)));
            y=floor(fxyc(inds(j,1),3,inds(j,2)));
            Bim(y,x)=1;
            singles=bwboundaries(Bim(:,:),'noholes');
        end
    end
    for i=1:length(singles)
        y(i)=singles{i,1}(1,1);
        x(i)=singles{i,1}(1,2);
        B(y(i),x(i),1)=bright;
        B(y(i),x(i),2)=0;
        B(y(i),x(i),3)=0;
    end
    
    
    colormap(gray);
    maximum=65535;
    C=B*(maximum/bright);
    image(C);
end