function IntensityNormalizer(file,newfile,frames) %takes movie from 'file', normalizes intensity so that the 95th percentile of the intensity distribution is set to 3000, then saves it to 'newfile'
h=waitbar(0,'Normalizing Images');
for j=1:7
    f=floor(frames*rand)+1;
    A(j,:,:)=imread(file,'Index',f);
end
[a,b,c]=size(A);
index=1;
for i=1:a
    for j=1:b
        for k=1:c
            inten(index)=A(i,j,k);
            index=index+1;
        end
    end
end
norm=prctile(inten,95);
norm=cast(norm,'double');
for i=1:frames
    waitbar(i/frames)
    B(:,:)=imread(file,'Index',i);
    
    B=B*(3000/norm);
    imwrite(B,newfile,'Writemode','append','Compression','none');
end
close(h)