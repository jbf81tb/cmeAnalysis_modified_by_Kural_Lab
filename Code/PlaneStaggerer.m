clear all
newfile='FullFlyTAv.tif';
file1='FlyStack2TAvPlane1.tif';
file2='FlyStack2TAv.tif';
file3='FlyStack2TAvPlane3.tif';
frames=308;
for i=1:frames
    for j=1:3
        if j==1
            file=file1;
        end
        if j==2
            file=file2;
        end
        if j==3
            file=file3;
        end
        A=imread(file,'Index',i);
        imwrite(A,newfile,'Writemode','append','Compression','none');
    end
end