function ColorInitiations(IMat,CMat,file,newfile) %adds colored spots to tif stack (named file--rewrites it in a file named newfile) at desired locations--fzzzmmmc is a nzzz4 matrizzz with the n spots--column 1 frame,column 2 zzz position, column 3 mmm position, column 4 color (1 for green, 2 for red)

frames=length(imfinfo(file));
h=waitbar(0,'Coloring Images');
A=imread(file,'Index',30);  %Will cause a problem if the movie is shorter than 30 frames
[n,m]=size(A);
list=zeros(1,n*m);
for i=1:n %Record all point intensities for this frame
    for i2=1:m
        list((i-1)*m+i2)=A(i,i2);
    end
end
bright=prctile(nonzeros(list),90); %Use intensities to find a suitable brightness to set points to
for i=1:frames
    clear A B
    A=imread(file,'Index',i);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    inds1=find(IMat(:,1)==i);
    for j=1:length(inds1)
        x=IMat(inds1(j),2);
        y=IMat(inds1(j),3);
        B(y,x,1)=0;
        B(y,x,2)=bright;
        B(y,x,3)=0;
        B(y,x+1,1)=0;
        B(y,x+1,2)=bright;
        B(y,x+1,3)=0;
        B(y+1,x,1)=0;
        B(y+1,x,2)=bright;
        B(y+1,x,3)=0;
        B(y+1,x+1,1)=0;
        B(y+1,x+1,2)=bright;
        B(y+1,x+1,3)=0;
    end
    inds2=find(CMat(:,1)==i);
    for j=1:length(inds2)
        x=CMat(inds2(j),2);
        y=CMat(inds2(j),3);
        B(y,x,1)=bright;
        B(y,x,2)=0;
        B(y,x,3)=0;
        B(y,x+1,1)=bright;
        B(y,x+1,2)=0;
        B(y,x+1,3)=0;
        B(y+1,x,1)=bright;
        B(y+1,x,2)=0;
        B(y+1,x,3)=0;
        B(y+1,x+1,1)=bright;
        B(y+1,x+1,2)=0;
        B(y+1,x+1,3)=0;
    end

    imwrite(B,newfile,'Writemode','append','Compression','none')
    waitbar(i/frames)
end
close(h);