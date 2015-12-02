clear all;
filename='fullfly.tif';
NewFileName='FlyStack2TAvPlane3';
for i=1:floor(1235/4)
    for j=1:4
        A(j,:,:)=imread(filename,'Index',12*(i-1)+(j-1)*3+3);
    end
    D(:,:)=A(1,:,:);
    for j=2:4
        C(:,:)=A(j,:,:);
        D=D+C;
    end
    D=floor(D/4);
    num=num2str(i);
    file=strcat(NewFileName,'.tif');
    imwrite(D,file,'Writemode','append');
end