function ColorSpotsByDensity(fxyc,file,newfile) %adds colored spots to tif stack (named file--rewrites it in a file named newfile) at desired locations--fxyc is a nX4 matrix with the n spots--column 1 frame,column 2 x position, column 3 y position, column 4 color (1 for green, 2 for red)
%strain should be in the 8th slot of fxyc
frames=length(imfinfo(file));
h=waitbar(0,'Coloring Images');
A=imread(file,'Index',1);
[n,m]=size(A);
maxtime=length(fxyc(:,1,1));
strains=[];
for i=1:length(fxyc(1,1,:))
    useds=find(fxyc(:,8,i));
    for j=1:length(useds)
        strains=[strains fxyc(useds(j),8,i)];
    end
end
maximum=prctile(abs(strains),90);
for i=1:frames
    clear A B
    A=imread(file,'Index',i);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    [a,b]=size(A);
    for L=1:maxtime
    inds=find(fxyc(L,1,:)==i);
    inds2=find(fxyc(L,8,:));
    inds=intersect(inds,inds2);
    for j=1:length(inds)
        x=fxyc(L,2,inds(j));
        y=fxyc(L,3,inds(j));
        c=max(-100,min(floor(fxyc(L,8,inds(j))/maximum*100),100));
        if y<a && x<b
            B(y,x,1)=c*30;
            B(y,x,2)=3000-c*30;
            B(y,x,3)=0;
            
            B(y,x+1,1)=c*30;
            B(y,x+1,2)=3000-c*30;
            B(y,x+1,3)=0;
            
            B(y+1,x,1)=c*30;
            B(y+1,x,2)=3000-c*30;
            B(y+1,x,3)=0;
            
            B(y+1,x+1,1)=c*30;
            B(y+1,x+1,2)=3000-c*30;
            B(y+1,x+1,3)=0;
        end
        
    end
    end
    imwrite(B,newfile,'Writemode','append','Compression','none')
    waitbar(i/frames)
end
close(h);