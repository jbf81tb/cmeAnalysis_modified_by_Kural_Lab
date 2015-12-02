function ColorSpots(fxyc,file,newfile) %adds colored spots to tif stack (named file--rewrites it in a file named newfile) at desired locations--fxyc is a nx4 matrix with the n spots--column 1 frame,column 2 x position, column 3 y position, column 4 color (1 for green, 2 for red)

frames=length(imfinfo(file));
for i=1:frames
    clear A B
    A=imread(file,'Index',i);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    inds=find(fxyc(:,4)==i);
    for j=1:length(inds)
        x=fxyc(inds(j),2);
        y=fxyc(inds(j),3);
        c=fxyc(inds(j),4);
        for k=1:4
            if c==2
                B(x+mod(k,2),y+floor((k-1)/2),1)=3000;
                B(x+mod(k,2),y+floor((k-1)/2),2)=0;
            end
            if c==2
                B(x+mod(k,2),y+floor((k-1)/2),1)=0;
                B(x+mod(k,2),y+floor((k-1)/2),2)=3000;
            end
            B(x+mod(k,2),y+floor((k-1)/2),3)=0;
        end
        B(x-1,y,1)=1000;
        B(x-1,y,2)=1000;
        B(x-1,y,3)=1000;
        B(x,y-1,1)=1000;
        B(x,y-1,2)=1000;
        B(x,y-1,3)=1000;
        B(x+1,y-1,1)=1000;
        B(x+1,y-1,2)=1000;
        B(x+1,y-1,3)=1000;
        B(x+2,y,1)=1000;
        B(x+2,y,2)=1000;
        B(x+2,y,3)=1000;
        B(x+2,y+1,1)=1000;
        B(x+2,y+1,2)=1000;
        B(x+2,y+1,3)=1000;
        B(x+1,y+2,1)=1000;
        B(x+1,y+2,2)=1000;
        B(x+1,y+2,3)=1000;
        B(x,y+2,1)=1000;
        B(x,y+2,2)=1000;
        B(x,y+2,3)=1000;
        B(x-1,y+1,1)=1000;
        B(x-1,y+1,2)=1000;
        B(x-1,y+1,3)=1000;
    end
    imwrite(B,newfile,'Writemode','append')
end