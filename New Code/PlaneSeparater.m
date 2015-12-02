movie='good_amneo.tif';
L=length(imfinfo(movie));
planes=3;
for i=1:L
    
    p=mod(i,planes);
    name=strcat('GAp',num2str(p),'.tif');
    A=imread(movie,'Index',i);
    imwrite(A,name,'Writemode','append');
end