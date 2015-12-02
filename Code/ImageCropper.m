clear all;
filename='ColdblockShort.tif';
NewFileName='ColdBack';
crop=[190 110 120 120]; %xmin ymin width height
h=waitbar(0,'');
for i=1:1
    A=imread(filename,'Index',i);
    C=imcrop(A,crop);
    file=strcat(NewFileName,'Crop','.tif');
    imwrite(C,file,'Writemode','append');
    waitbar(i/1235)
end
close(h);