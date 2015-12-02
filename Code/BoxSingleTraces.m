function BoxSingleTraces(fxyc,traces,file,newfile) %adds colored spots to tif stack (named file--rewrites it in a file named newfile) at desired locations--fzzzmmmc is a nzzz4 matrizzz with the n spots--column 1 frame,column 2 zzz position, column 3 mmm position, column 4 color (1 for green, 2 for red)
%traces is a vector with the desired trace numbers
frames=length(imfinfo(file));
h=waitbar(0,'Coloring Images');
A=imread(file,'Index',1);
[n,m]=size(A);
maxtime=length(fxyc(:,1,1));
for i=1:frames
    clear A B
    A=imread(file,'Index',i);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    inds=find(fxyc(1,1,:)==i);
    
    for j=1:length(inds)
        if ismember(inds(j),traces)
        x=fxyc(1,2,inds(j));
        y=fxyc(1,3,inds(j));
        c=fxyc(1,4,inds(j));
        if x~=0 && y~=0
            for xoff=-3:3
                for yoff=-3:3
                    if abs(xoff)==3 || abs(yoff)==3
            B(y+yoff,x+xoff,1)=3000;
            B(y+yoff,x+xoff,2)=0;
            B(y+yoff,x+xoff,3)=0;
                    end
                end
            end
        end
        end
    end
    for time=2:maxtime
        inds=find(fxyc(time,1,:)==i);
        for j=1:length(inds)
            if ismember(inds(j),traces)
            t=time;
            c=fxyc(time,4,inds(j));
            
            Tlength=length(find(fxyc(:,1,inds(j))));
            while t==time  %Draw lines to all previous points on trace
                p2=[fxyc(t,3,inds(j)) fxyc(t,2,inds(j))];
                p1=[fxyc(t-1,3,inds(j)) fxyc(t-1,2,inds(j))];
                int=fxyc(t,5,inds(j));
                p=PointsInLine(p1,p2);
                if p1(1)~=0 && p1(2)~=0 && p2(1)~=0 && p2(2)~=0
                    for k=2:length(p(:,1))
                        y=p(k,1);
                        x=p(k,2);
                        for xoff=-3:3
                            for yoff=-3:3
                                if abs(xoff)==3 || abs(yoff)==3
                                    B(y+yoff,x+xoff,1)=3000;
                                    B(y+yoff,x+xoff,2)=0;
                                    B(y+yoff,x+xoff,3)=0;
                                end
                            end
                        end
                    end
                end
                t=t-1;
                
            end
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