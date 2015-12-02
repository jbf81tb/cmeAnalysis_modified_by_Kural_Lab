function ColorMultiPlaneTraces(fxycpath,file,newfile,corrpath) %adds colored spots to tif stack (named file--rewrites it in a file named newfile) at desired locations--fzzzmmmc is a nzzz4 matrizzz with the n spots--column 1 frame,column 2 zzz position, column 3 mmm position, column 4 color (1 for green, 2 for red)

correspondences=[];
load(fxycpath)
fxyc=Threshfxyc;
load(corrpath);
if isempty(correspondences)
    maxL=Totalmax;
else
maxL=max(correspondences,[],1);
end
comp=10; %shortest trace correspondence that is recorded
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
        if maxL(inds(j))>=comp
        x=fxyc(1,2,inds(j));
        y=fxyc(1,3,inds(j));
        c=fxyc(1,4,inds(j));
        if c==2
            B(y,x,1)=3000;
            B(y,x,2)=0;
            B(y,x,3)=0;
        end
        if c==1
            B(y,x,1)=3000;
            B(y,x,2)=0;
            B(y,x,3)=3000;
        end
        if c==3
            B(y,x,1)=0;
            B(y,x,2)=3000;
            B(y,x,3)=0;
        end
        if c==4
            B(y,x,1)=3000;
            B(y,x,2)=3000;
            B(y,x,3)=0;
        end
        if c==5
            B(y,x,1)=0;
            B(y,x,2)=3000;
            B(y,x,3)=3000;
        end
        end
    end
    for time=2:maxtime
        inds=find(fxyc(time,1,:)==i);
        for j=1:length(inds)
            if maxL(inds(j))>=comp
            t=time;
            c=fxyc(time,4,inds(j));
            
            Tlength=length(find(fxyc(:,1,inds(j))));
            while t>1  %Draw lines to all previous points on trace
                p2=[fxyc(t,3,inds(j)) fxyc(t,2,inds(j))];
                p1=[fxyc(t-1,3,inds(j)) fxyc(t-1,2,inds(j))];
                int=fxyc(t,5,inds(j));
                p=PointsInLine(p1,p2);
                for k=2:length(p(:,1))
                    y=p(k,1);
                    x=p(k,2);
                    
                    if c==2 %end but no beginning
                        B(y,x,1)=3000;
                        B(y,x,2)=0;
                        B(y,x,3)=0;
                    end
                    if c==1 %beginning but no end
                        B(y,x,1)=3000;
                        B(y,x,2)=0;
                        B(y,x,3)=3000;
                    end
                    if c==3 %beginning and end
                        B(y,x,1)=0;  %0+3000*(t-2)/(Tlength-2);
                        B(y,x,2)=3000;  %3000-3000*(t-2)/(Tlength-2);
                        B(y,x,3)=0;
                    end
                    if c==4
                        B(y,x,1)=3000;
                        B(y,x,2)=3000;
                        B(y,x,3)=0;
                    end
                    if c==5
                        B(y,x,1)=0;
                        B(y,x,2)=3000;
                        B(y,x,3)=3000;
                    end
                    if int==0
                        B(y,x,1)=0;
                        B(y,x,2)=0;
                        B(y,x,3)=3000;
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