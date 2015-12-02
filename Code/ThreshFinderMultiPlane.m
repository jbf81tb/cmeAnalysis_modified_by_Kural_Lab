clear all;
path1='FlyPlane1FoundSpots.mat';
path2='FlyPlane2FoundSpots.mat';
path3='FlyPlane3FoundSpots.mat';
movie1='FlyStack2TAv.tif';
movie2='FlyStack2TAvPlane1.tif';
movie3='FlyStack2TAvPlane3.tif';
NewMovie='FlyColocalizations100_';
NewMovie1=strcat(NewMovie,num2str(1),'.tif');
NewMovie2=strcat(NewMovie,num2str(2),'.tif');
NewMovie3=strcat(NewMovie,num2str(3),'.tif');
maxdist=2; %Maximum distance two spots can be separated by and still called the same


load(path1)
FoundSpots1=FoundSpots;
load(path2)
FoundSpots2=FoundSpots;
load(path3)
FoundSpots3=FoundSpots;
frames=max(FoundSpots(:,1));
i1=30; %frame to look at spots on
inds1=[];
inds2=[];
inds1a=find(FoundSpots1(:,1)==i1);
inds2a=find(FoundSpots2(:,1)==i1);
found=[];
done=false;
while done==false
     Thresh=input('Thresh= (0 to quit) ');
    close
    if Thresh==0
        break
    end
    inds1b=find(FoundSpots1(:,4)>=Thresh);
    inds2b=find(FoundSpots2(:,4)>=Thresh);
    inds1=intersect(inds1a,inds1b);
    inds2=intersect(inds2a,inds2b);
for i2=1:length(inds1) %Indentify spots in plane 1 that have a corresponding spot <=maxdist away from them in plane 2
    x1=FoundSpots1(inds1(i2),2);
    y1=FoundSpots1(inds1(i2),3);
    for i3=1:length(inds2)
        x2=FoundSpots2(inds2(i3),2);
        y2=FoundSpots2(inds2(i3),3);
        dist=sqrt((x1-x2)^2+(y1-y2)^2);
        if dist<=maxdist
            found=[found;[i2 i3]];
        end
    end
end
A1=imread(movie1,'Index',i1);
A2=imread(movie2,'Index',i1);
A3=imread(movie3,'Index',i1);
bright=max(max(A1))/1.5;
B1(:,:,1)=A1;
B1(:,:,2)=A1;
B1(:,:,2)=A1;
B2(:,:,1)=A2;
B2(:,:,2)=A2;
B2(:,:,2)=A2;
B3(:,:,1)=A3;
B3(:,:,2)=A3;
B3(:,:,2)=A3;
for i2=1:length(found(:,1)) %Color found colocalizations
    x1=floor(FoundSpots1(inds1(found(i2,1)),2));
    y1=floor(FoundSpots1(inds1(found(i2,1)),3));
    x2=floor(FoundSpots2(inds2(found(i2,2)),2));
    y2=floor(FoundSpots2(inds2(found(i2,2)),3));
    B1(y1,x1,1)=2000;
    B1(y1,x1,2)=0;
    B1(y1,x1,3)=0;
    B2(y2,x2,1)=2000;
    B2(y2,x2,2)=0;
    B2(y2,x2,3)=0;
end
    colormap(gray);
    maximum=65535;
    C=B1*(maximum/bright);
    image(C);
end
