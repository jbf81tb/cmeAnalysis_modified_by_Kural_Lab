clear all;
clear all;
%This program finds the value of Thresh you should use in TrackWrapper
%When you run it, pick a Thresh value (on the order of 100), it will show
%which spots are above that value.  Keep trying values until you're
%satisfied with the results

%Parameters that need to be set
path='FlyECropP2fxycMHZ.mat'; %The file that you saved the traces to in the first run of TrackWrapper
file='FlyECropP2.tif'; %File to trace on
fxyc=[];
load(path);
done=false;
[a,~]=size(FoundSpots);
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
    ind=find(FoundSpots(:,1)==frame);
    bright=max(max(A))/1.25;
    [L]=length(ind);
    Bim=zeros(b,c);
    for j=1:L
        if FoundSpots(ind(j),4)>=Thresh
        x=floor(FoundSpots(ind(j),2));
        y=floor(FoundSpots(ind(j),3));
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