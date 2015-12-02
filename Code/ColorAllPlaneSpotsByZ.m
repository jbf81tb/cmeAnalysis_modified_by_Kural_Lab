clear all; %This program is meant to identify and color spots found in multiple adjacent frames
path1='FlyP1ManualInt175.mat';
path2='FlyP2MIHWHM175.mat';
path3='FlyP3ManualInt175.mat';
ExCorrPath12='FlyExcorrespondences12M1.mat';
ExCorrPath32='FlyExcorrespondences32M1.mat';
movie2='FlyStack2TAv.tif';
movie1='FlyStack2TAvPlane1.tif';
movie3='FlyStack2TAvPlane3.tif';
NewMovie='FlyBigSpotsZMI4_';
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
ints=[];
for i=1:length(fxyc2(:,1,1))
    for i2=1:length(fxyc2(1,1,:))
        if fxyc2(i,8,i2)~=0
            ints=[ints fxyc2(i,8,i2)];
        end
    end
end
BigThresh=prctile(ints,90);
for i=1:length(OfInterest) %Go through all detected spots that are in all plane
    waitbar(i/length(OfInterest))
    for i2=1:length(ExCorr12(:,OfInterest(i))) %Find trace from that spot in plane 1
        Temp=ExCorr12{i2,OfInterest(i)};
        if ~isempty(Temp) 
            for i3=1:length(Temp) %Go through all frames where the traces are together
                wanted=find(fxyc1(:,1,i2)==Temp(i3));
                int=fxyc1(wanted(1),8,i2); %Find intensity in plane 1
                I1(i,Temp(i3))=max(I1(i,Temp(i3)),int); %Keep track of the highest one
            end
        end
    end
    for i2=1:length(ExCorr32(:,OfInterest(i))) %Find trace from that spot in plane 3
        Temp=ExCorr32{i2,OfInterest(i)};
        if ~isempty(Temp) 
            for i3=1:length(Temp) %Go through all frames where the traces are together
                wanted=find(fxyc3(:,1,i2)==Temp(i3));
                int=fxyc3(wanted(1),8,i2); %Find intensity in plane 3
                I3(i,Temp(i3))=max(I3(i,Temp(i3)),int); %Keep track of the highest one, to determine z position later
            end
        end
    end
    used2=find(fxyc2(:,1,OfInterest(i)));
    for i2=1:length(used2) %Same thing for plane 2--Simpler because Selected is in terms of plane 2 traces
        int=fxyc2(used2(i2),8,OfInterest(i));
        I2(i,fxyc2(used2(i2),1,OfInterest(i)))=max(I2(i,fxyc2(used2(i2),1,OfInterest(i))),int);
    end
end
close(h)
h=waitbar(0,'Coloring');
MinInt12=min(I1,I2);
MinInt=min(MinInt12,I3);
zs=[];
selected2=[];
for i=1:frames
  
    A2=imread(movie2,'Index',i);
 

    B2(:,:,1)=A2;
    B2(:,:,2)=A2;
    B2(:,:,3)=A2;

    found=find(MinInt(:,i));
    for i2=1:length(found) %Color found colocalizations
        z=(I1(found(i2),i)+2*I2(found(i2),i)+3*I3(found(i2),i))/(I1(found(i2),i)+I2(found(i2),i)+I3(found(i2),i)); %Calculate z position by finding where the intensity is centered
        zs=[zs z];
        
        ind1=find(fxyc2(:,1,OfInterest(found(i2)))==i);
        HWHM=fxyc2(ind1(1),9,OfInterest(found(i2)));
        x2=fxyc2(ind1(1),2,OfInterest(found(i2)));
        y2=fxyc2(ind1(1),3,OfInterest(found(i2)));
       
        B2(y2,x2,1)=max(4000*(2.5-z),0);
        B2(y2,x2,2)=max(4000*(z-1.5),0);
        B2(y2,x2,3)=0;
        
        if HWHM>1.2 && HWHM<4 && z>=2.1 %&& I2(found(i2),i)>=BigThresh
            selected2=[selected2 OfInterest(found(i2))];
        end
    end

    %imwrite(B2,NewMovie2,'Writemode','append','Compression','none');
    waitbar(i/frames);
end
save FlyBigSpotsZ21HWHM12.mat selected2
close(h);