clear all;
%Files to be loaded
path2='FlyP2fxycMH175_2.mat';
movie1='FlyStack2TAvPlane1.tif';
movie2='FlyStack2TAv.tif';
movie3='FlyStack2TAvPlane3.tif';
%Load files, initialize other variables
load(path2)
fxyc2=fxyc;
frames=max(max(fxyc2(:,1,:)));
OfInterest=find(fxyc2(1,1,:));
I1=zeros(length(OfInterest),frames);
I2=zeros(length(OfInterest),frames);
I3=zeros(length(OfInterest),frames);

h=waitbar(0,'Finding Axial Positions');
for i3=1:frames
    waitbar(i3/frames)
    M1=imread(movie1,'Index',i3);
    M2=imread(movie2,'Index',i3);
    M3=imread(movie3,'Index',i3);
    for i=1:length(OfInterest)
        used2=find(fxyc2(:,1,OfInterest(i))==i3);
        for i2=1:length(used2)
            int=fxyc2(used2(i2),8,OfInterest(i));
            x=fxyc2(used2(i2),2,OfInterest(i));
            y=fxyc2(used2(i2),3,OfInterest(i));
            Sint=CalculateInt(M2,x,y);
            I1(i,fxyc2(used2(i2),1,OfInterest(i)))=CalculateInt(M1,x,y);
            I3(i,fxyc2(used2(i2),1,OfInterest(i)))=CalculateInt(M3,x,y);
            I2(i,fxyc2(used2(i2),1,OfInterest(i)))=max(I2(i,fxyc2(used2(i2),1,OfInterest(i))),Sint);
            offset=min(min(I1(i,fxyc2(used2(i2),1,OfInterest(i))),I2(i,fxyc2(used2(i2),1,OfInterest(i)))),I3(i,fxyc2(used2(i2),1,OfInterest(i))));
            z=(1*I1(i,fxyc2(used2(i2),1,OfInterest(i)))+2*I2(i,fxyc2(used2(i2),1,OfInterest(i)))+3*I3(i,fxyc2(used2(i2),1,OfInterest(i)))-6*offset)/(I1(i,fxyc2(used2(i2),1,OfInterest(i)))+I2(i,fxyc2(used2(i2),1,OfInterest(i)))+I3(i,fxyc2(used2(i2),1,OfInterest(i)))-3*offset);
            fxyc2(used2(i2),10,OfInterest(i))=z;
        end
    end
end

close(h)
fxyc=fxyc2;
save FlyP2fxycMHZwoT_offset_SymmI2.mat fxyc
