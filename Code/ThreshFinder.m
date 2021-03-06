clear all;
%This program finds the value of Thresh you should use in TrackWrapper
%When you run it, pick a Thresh value (on the order of 100), it will show
%which spots are above that value.  Keep trying values until you're
%satisfied with the results

%Parameters that need to be set
path='FlyP2fxycMHZ_NEW.mat'; %The file that you saved the traces to in the first run of TrackWrapper
file='FlyStack2TAv.tif'; %File to trace on
fxyc=[];
load(path);

IntSlot=8; %which slot of the fxyc holds the desired int data (5 or 8)
if isempty(fxyc)
    fxyc=Threshfxyc;
end
load(path);
done=false;
%fxyc=Threshfxyc;
[a,~,~]=size(fxyc);
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
        if fxyc(inds(j,1),IntSlot,inds(j,2))>=Thresh
        x=fxyc(inds(j,1),2,inds(j,2));
        y=fxyc(inds(j,1),3,inds(j,2));
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