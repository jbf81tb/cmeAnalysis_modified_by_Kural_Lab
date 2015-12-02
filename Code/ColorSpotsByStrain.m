function ColorSpotsByStrain(fxyc,file,newfile) %adds colored spots to tif stack (named file--rewrites it in a file named newfile) at desired locations--fxyc is a nX4 matrix with the n spots--column 1 frame,column 2 x position, column 3 y position, column 4 color (1 for green, 2 for red)
%strain should be in the 9th slot of fxyc
%z postion should be in the 10th slot
%Manually Calculated intensity should be in the 8th slot
slot=10; %Change to change what is being colored
frames=length(imfinfo(file));
h=waitbar(0,'Coloring Images');
A=imread(file,'Index',1);
[n,m]=size(A);
maxtime=length(fxyc(:,1,1));
cmap=jet(64)*6000;
strains=[];
for i=1:length(fxyc(1,1,:))
    useds=find(fxyc(:,slot,i));
    for j=1:length(useds)
        strains=[strains fxyc(useds(j),slot,i)];
    end
end
maximum=prctile(abs(strains),90);
minimum=prctile(abs(strains),10);
for i=1:frames
    clear A B
    A=imread(file,'Index',i);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    [a,b]=size(A);
    for L=1:maxtime
    inds=find(fxyc(L,1,:)==i);
    inds2=find(fxyc(L,slot,:));
    inds=intersect(inds,inds2);
    for j=1:length(inds)
        x=fxyc(L,2,inds(j));
        y=fxyc(L,3,inds(j));
        c=fxyc(L,slot,inds(j));
        usede=find(fxyc(:,10,inds(j)));
        usedr=find(fxyc(:,9,inds(j))>=.8);
        used=intersect(usede,usedr);
        if ~isempty(used) && length(used)>=5
            ints=fxyc(used,5,inds(j));
            cs=fxyc(used,slot,inds(j));
            sorted=sort(cs);
    wanted=find(sorted,5,'last');
    maxrs=sorted(wanted);
            mints=mean(ints);
            mc=max(cs);
            mec=mean(maxrs);
        else
            mints=0;
            mc=0;
            mec=0;
        end
        
        if y<a-1 && x<b-1
%             B(y,x,1)=1500+c*15; Coloring from red to green without
%             colormap
%             B(y,x,2)=1500-c*15;
%             B(y,x,3)=0;
%             
%             B(y,x+1,1)=1500+c*15;
%             B(y,x+1,2)=1500-c*15;
%             B(y,x+1,3)=0;
%             
%             B(y+1,x,1)=1500+c*15;
%             B(y+1,x,2)=1500-c*15;
%             B(y+1,x,3)=0;
%
%             B(y+1,x+1,1)=1500+c*15;
%             B(y+1,x+1,2)=1500-c*15;
%             B(y+1,x+1,3)=0;
if c>0
    if  mec>=.7725
        B(y,x,:)=cmap(64,:);
    else
        if mec>=.7032
            B(y,x,:)=[0 6000 0];
        else
            if mec>=.6384
                B(y,x,:)=[6000 6000 0];
            else
                B(y,x,:)=cmap(1,:);
            end
        end
        
    end
end
%             B(y,x+1,:)=cmap(c+33,:);
%             B(y+1,x,:)=cmap(c+33,:);
%             B(y+1,x+1,:)=cmap(c+33,:);
%             B(y+2,x,:)=cmap(c+33,:);
%             B(y,x+2,:)=cmap(c+33,:);
%             B(y+1,x+2,:)=cmap(c+33,:);
%             B(y+2,x+1,:)=cmap(c+33,:);
%             B(y+2,x+2,:)=cmap(c+33,:);
        end
        
    end
    end
    imwrite(B,newfile,'Writemode','append','Compression','none')
    waitbar(i/frames)
end
close(h);