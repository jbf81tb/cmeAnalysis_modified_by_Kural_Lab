clear all;
path1='FlyPlane1Threshfxyc125.mat';
path2='FlyPlane2Threshfxyc125.mat';
path3='FlyPlane3Threshfxyc125.mat';
movie1='FlyStack2TAv.tif';
movie2='FlyStack2TAvPlane1.tif';
movie3='FlyStack2TAvPlane3.tif';
NewMovie='FlyColocalizationsControl125_';
NewMovie1=strcat(NewMovie,num2str(1),'.tif');
NewMovie2=strcat(NewMovie,num2str(2),'.tif');
NewMovie3=strcat(NewMovie,num2str(3),'.tif');
maxdist=2; %Maximum distance two spots can be separated by and still called the same


load(path1)
fxyc1=Threshfxyc;
load(path2)
fxyc2=Threshfxyc;
load(path3)
fxyc3=Threshfxyc;
frames=max(max(fxyc1(:,1,:)));
h=waitbar(0,'Finding and Coloring Colocalizations');
for i1=1:frames
    inds1=[];
    inds2=[];
    for i2=1:length(fxyc2(:,1,1)) %Find all spots found in the current frame in plane 1
        for i3=1:length(fxyc2(1,1,:))
            if fxyc2(i2,1,i3)==i1
                inds2=[inds2;[i2 i3]];
            end
        end
    end
    A1=imread(movie1,'Index',i1);
    A2=imread(movie2,'Index',i1);
    A3=imread(movie3,'Index',i1);
    B1(:,:,1)=A1;
    B1(:,:,2)=A1;
    B1(:,:,2)=A1;
    B2(:,:,1)=A2;
    B2(:,:,2)=A2;
    B2(:,:,2)=A2;
    B3(:,:,1)=A3;
    B3(:,:,2)=A3;
    B3(:,:,2)=A3;
    for i2=1:length(inds2(:,1)) %Color found colocalizations
        %x1=fxyc1(inds1(i2,1),2,inds1(i2,2));
        %y1=fxyc1(inds1(i2,1),3,inds1(i2,2));
        x2=fxyc2(inds2(i2,1),2,inds2(i2,2));
        y2=fxyc2(inds2(i2,1),3,inds2(i2,2));
        %B1(y1,x1,1)=2000;
        %B1(y1,x1,2)=0;
        %B1(y1,x1,3)=0;
        B2(y2,x2,1)=2000;
        B2(y2,x2,2)=0;
        B2(y2,x2,3)=0;
    end
    %imwrite(B1,NewMovie1,'Writemode','append','Compression','none');
    imwrite(B2,NewMovie2,'Writemode','append','Compression','none');
    waitbar(i1/frames);
end
close(h);