clear all;
filename='coldblock_cell_2002.tif';
NewFileName='ColdblockBeginning_300.tif';
for i=1:300
    clear A
    A(:,:)=imread(filename,'Index',i); 
    file=strcat(NewFileName);
    imwrite(A,file,'Writemode','append');
end