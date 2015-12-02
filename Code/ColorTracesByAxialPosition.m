function ColorTracesByAxialPosition(fxyc,file,newfile) %adds colored spots to tif stack (named file--rewrites it in a file named newfile) at desired locations--fzzzmmmc is a nzzz4 matrizzz with the n spots--column 1 frame,column 2 zzz position, column 3 mmm position, column 4 color (1 for green, 2 for red)

frames=length(imfinfo(file));
h=waitbar(0,'Coloring Images');
A=imread(file,'Index',1);
[n,m]=size(A);
maxtime=length(fxyc(:,1,1));
strains=[];
for i=1:length(fxyc(1,1,:))
    useds1=find(fxyc(:,10,i));
    useds2=find(fxyc(:,4,i)==3);
    useds=intersect(useds1,useds2);
    for j=1:length(useds)
        strains=[strains fxyc(useds(j),10,i)-2];
    end
end
maximum=prctile(abs(strains),90);
for i=1:frames
    clear A B
    A=imread(file,'Index',i);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    inds1=find(fxyc(1,1,:)==i);
    inds2=find(fxyc(1,4,:));
    inds=intersect(inds1,inds2);
    for j=1:length(inds)
        x=fxyc(1,2,inds(j));
        y=fxyc(1,3,inds(j));
        c=max(-100,min(floor((fxyc(1,10,inds(j))-2)/maximum*100),100));
        B(y,x,1)=1500+c*15;
        B(y,x,2)=1500-c*15;
        B(y,x,3)=0;
    end
    for time=2:maxtime
        inds1=find(fxyc(time,1,:)==i);
        inds2=find(fxyc(time,4,:));
        inds=intersect(inds1,inds2);
        for j=1:length(inds)
            t=time;
            %c=fxyc(time,4,inds(j));
            
            Tlength=length(find(fxyc(:,1,inds(j))));
            while t>1  %Draw lines to all previous points on trace
                p2=[fxyc(t,3,inds(j)) fxyc(t,2,inds(j))];
                p1=[fxyc(t-1,3,inds(j)) fxyc(t-1,2,inds(j))];
                c=max(-100,min(floor((fxyc(t-1,10,inds(j))-2)/maximum*100),100));
                int=fxyc(t,5,inds(j));
                p=PointsInLine(p1,p2);
                for k=2:length(p(:,1))
                    y=p(k,1);
                    x=p(k,2);
                    B(y,x,1)=1500+c*15;
                    B(y,x,2)=1500-c*15;
                    B(y,x,3)=0;
                    
                end
                t=t-1;
            end
        end
    
%         if y>=3 && x>=2 && y<=n-3 && x<=m-3
%             %B(y-2,x,1)=1000;
%             %B(y-2,x,2)=1000;
%             %B(y-2,x,3)=1000;
%         for k=1:4
%             if c==2
%                 B(y+mod(k,2),x+floor((k-1)/2),1)=3000;
%                 B(y+mod(k,2),x+floor((k-1)/2),2)=0;
%             end
%             if c==1
%                 B(y+mod(k,2),x+floor((k-1)/2),1)=0;
%                 B(y+mod(k,2),x+floor((k-1)/2),2)=3000;
%             end
%             B(y+mod(k,2),x+floor((k-1)/2),3)=0;
%         end
%         B(y-1,x,1)=1000;
%         B(y-1,x,2)=1000;
%         B(y-1,x,3)=1000;
%         B(y,x-1,1)=1000;
%         B(y,x-1,2)=1000;
%         B(y,x-1,3)=1000;
%         B(y+1,x-1,1)=1000;
%         B(y+1,x-1,2)=1000;
%         B(y+1,x-1,3)=1000;
%         B(y+2,x,1)=1000;
%         B(y+2,x,2)=1000;
%         B(y+2,x,3)=1000;
%         B(y+2,x+1,1)=1000;
%         B(y+2,x+1,2)=1000;
%         B(y+2,x+1,3)=1000;
%         B(y+1,x+2,1)=1000;
%         B(y+1,x+2,2)=1000;
%         B(y+1,x+2,3)=1000;
%         B(y,x+2,1)=1000;
%         B(y,x+2,2)=1000;
%         B(y,x+2,3)=1000;
%         B(y-1,x+1,1)=1000;
%         B(y-1,x+1,2)=1000;
%         B(y-1,x+1,3)=1000;
%         end
    
    end
    imwrite(B,newfile,'Writemode','append','Compression','none')
    waitbar(i/frames)
end
close(h);