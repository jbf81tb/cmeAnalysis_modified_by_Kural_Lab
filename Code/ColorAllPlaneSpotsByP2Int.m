clear all; %This program is meant to identify and color spots found in multiple adjacent frames
path1='FlyP1fxycMHZ.mat';
path2='FlyP2fxycMHZ_NEW.mat';
path3='FlyP3fxycMHZ.mat';
ExCorrPath12='FlyExcorrespondences12_175_NEW.mat';
ExCorrPath32='FlyExcorrespondences32_175_NEW.mat';
movie1='FlyStack2TAv.tif';
movie2='FlyStack2TAvPlane1.tif';
movie3='FlyStack2TAvPlane3.tif';
NewMovie='FlyBigSpotsP2Int_NEW';
NewMovie1=strcat(NewMovie,num2str(1),'.tif');
NewMovie2=strcat(NewMovie,num2str(2),'.tif');
NewMovie3=strcat(NewMovie,num2str(3),'.tif');
mode=2; %Mode 2 only colors spots denoted by 1 in the "Selected" vector
if mode==2
    load('FlyBigSpots.mat')
end
maxdist=2; %Maximum distance two spots can be separated by and still called the same


load(path1)
fxyc1=fxyc;
load(path2)
fxyc2=fxyc;
load(path3)
fxyc3=fxyc;
load(ExCorrPath12)
ExCorr12=Excorrespondences;
load(ExCorrPath32)
ExCorr32=Excorrespondences;
frames=max(max(fxyc1(:,1,:)));
h=waitbar(0,'Finding Colocalizations');
OfInterest=find(Selected);
I1=zeros(length(OfInterest),frames);
I2=zeros(length(OfInterest),frames);
I3=zeros(length(OfInterest),frames);
for i=1:length(OfInterest) %Go through all detected spots that are in all plane
    waitbar(i/length(OfInterest))
    for i2=1:length(ExCorr12(:,OfInterest(i))) %Find trace from that spot in plane 1
        Temp=ExCorr12{i2,OfInterest(i)};
        if ~isempty(Temp) 
            for i3=1:length(Temp) %Go through all frames where the traces are together
                wanted=find(fxyc1(:,1,i2)==Temp(i3));
                int=fxyc1(wanted(1),5,i2); %Find intensity in plane 1
                I1(i,Temp(i3))=max(I1(i,Temp(i3)),int); %Keep track of the highest one
            end
        end
    end
    for i2=1:length(ExCorr32(:,OfInterest(i))) %Find trace from that spot in plane 3
        Temp=ExCorr32{i2,OfInterest(i)};
        if ~isempty(Temp) 
            for i3=1:length(Temp) %Go through all frames where the traces are together
                wanted=find(fxyc3(:,1,i2)==Temp(i3));
                int=fxyc3(wanted(1),5,i2); %Find intensity in plane 3
                I3(i,Temp(i3))=max(I3(i,Temp(i3)),int); %Keep track of the highest one, to determine z position later
            end
        end
    end
    used2=find(fxyc2(:,1,OfInterest(i)));
    for i2=1:length(used2) %Same thing for plane 2--Simpler because Selected is in terms of plane 2 traces
        int=fxyc2(used2(i2),5,OfInterest(i));
        I2(i,fxyc2(used2(i2),1,OfInterest(i)))=max(I2(i,fxyc2(used2(i2),1,OfInterest(i))),int);
    end
end
close(h)
h=waitbar(0,'Coloring');
MinInt12=min(I1,I2);
MinInt=min(MinInt12,I3);
[A,B]=size(I2);
ints=[];
for i1=1:A
    for i2=1:B
        if I2(i1,i2)~=0
            ints=[ints I2(i1,i2)];
        end
    end
end
norm=prctile(ints,97);
for i=1:frames
  
    A2=imread(movie2,'Index',i);
 

    B2(:,:,1)=A2;
    B2(:,:,2)=A2;
    B2(:,:,3)=A2;

    found=find(MinInt(:,i));

    for i2=1:length(found) %Color found colocalizations
        z=min(I2(found(i2),i)/norm,1); %Calculate z position by finding where the intensity is centered
        ind1=find(fxyc2(:,1,OfInterest(found(i2)))==i);
        x2=fxyc2(ind1(1),2,OfInterest(found(i2)));
        y2=fxyc2(ind1(1),3,OfInterest(found(i2)));
       
        B2(y2,x2,1)=2000*(z);
        B2(y2,x2,2)=2000*(1-z);
        B2(y2,x2,3)=0;
        
    end

    imwrite(B2,NewMovie2,'Writemode','append','Compression','none');
    waitbar(i/frames);
end
close(h);