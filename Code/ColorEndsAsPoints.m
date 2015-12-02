function ColorEndsAsPoints(fxyc,file,newfile)
%Same as ColorSpots, but only color beginnings (green) and ends (red)

frames=length(imfinfo(file));
h=waitbar(0,'Coloring Images');
A=imread(file,'Index',1);
[n,m]=size(A);
maxtime=length(fxyc(:,1,1));
L=4;
for i=1:frames
    clear A B
    A=imread(file,'Index',i);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    for k=1:length(fxyc(:,1,1))
    inds=find(fxyc(k,1,:)==i);
    
    for j=1:length(inds)
        x=fxyc(k,2,inds(j));
        y=fxyc(k,3,inds(j));
        c=fxyc(k,4,inds(j));
        if c==2
            for ix=1:4
                for iy=-1*L:L
                    if ix==1
                        B(y-L,x+iy,1)=3000;
                        B(y-L,x+iy,2)=0;
                        B(y-L,x+iy,3)=0;
                    end
                    if ix==2
                        B(y+L,x+iy,1)=3000;
                        B(y+L,x+iy,2)=0;
                        B(y+L,x+iy,3)=0;
                    end
                    if ix==3
                        B(y+iy,x-L,1)=3000;
                        B(y+iy,x-L,2)=0;
                        B(y+iy,x-L,3)=0;
                    end
                    if ix==4
                        B(y+iy,x+L,1)=3000;
                        B(y+iy,x+L,2)=0;
                        B(y+iy,x+L,3)=0;
                    end
                end
            end
        end
        if c==1
            for ix=1:4
                for iy=-1*L:L
                    if ix==1
                        B(y-L,x+iy,1)=0;
                        B(y-L,x+iy,2)=3000;
                        B(y-L,x+iy,3)=0;
                    end
                    if ix==2
                        B(y+L,x+iy,1)=0;
                        B(y+L,x+iy,2)=3000;
                        B(y+L,x+iy,3)=0;
                    end
                    if ix==3
                        B(y+iy,x-L,1)=0;
                        B(y+iy,x-L,2)=3000;
                        B(y+iy,x-L,3)=0;
                    end
                    if ix==4
                        B(y+iy,x+L,1)=0;
                        B(y+iy,x+L,2)=3000;
                        B(y+iy,x+L,3)=0;
                    end
                end
            end
        end
        if c==3
            for ix=1:4
                for iy=-1*L:L
                    if ix==1
                        B(y-L,x+iy,1)=0;
                        B(y-L,x+iy,2)=3000;
                        B(y-L,x+iy,3)=0;
                    end
                    if ix==2
                        B(y+L,x+iy,1)=0;
                        B(y+L,x+iy,2)=3000;
                        B(y+L,x+iy,3)=0;
                    end
                    if ix==3
                        B(y+iy,x-L,1)=0;
                        B(y+iy,x-L,2)=3000;
                        B(y+iy,x-L,3)=0;
                    end
                    if ix==4
                        B(y+iy,x+L,1)=0;
                        B(y+iy,x+L,2)=3000;
                        B(y+iy,x+L,3)=0;
                    end
                end
            end
        end
    end
    end
%     for time=2:maxtime
%         inds=find(fxyc(time,1,:)==i);
%         for j=1:length(inds)
%             t=time;
%             c=fxyc(time,4,inds(j));
%             
%             Tlength=length(find(fxyc(:,1,inds(j))));
%             Last=find(fxyc(:,1,inds(j)),1,'last');
%             while t>1  %Draw lines to all previous points on trace
%                 p2=[fxyc(t,3,inds(j)) fxyc(t,2,inds(j))];
%                 p1=[fxyc(t-1,3,inds(j)) fxyc(t-1,2,inds(j))];
%                 int=fxyc(t,5,inds(j));
%                 p=PointsInLine(p1,p2);
%                 for k=2:length(p(:,1))
%                     y=p(k,1);
%                     x=p(k,2);
%                     
%                     if c==2 %end but no beginning
%                         B(y,x,1)=3000;
%                         B(y,x,2)=0;
%                         B(y,x,3)=0;
%                     end
%                     if c==1 %beginning but no end
%                         B(y,x,1)=0;
%                         B(y,x,2)=3000;
%                         B(y,x,3)=0;
%                     end
%                     if c==3 && t<=3 && time<=3
%                         B(y,x,1)=0;
%                         B(y,x,2)=3000;
%                         B(y,x,3)=0;
%                     end
%                     if c==3 && t>=Last(1)-2 && time>=Last(1)-2
%                         B(y,x,1)=3000;
%                         B(y,x,2)=0;
%                         B(y,x,3)=0;
%                     end
%                 end
%                 t=t-1;
%             end
%         end
%     end
    imwrite(B,newfile,'Writemode','append','Compression','none')
    waitbar(i/frames)
end
close(h);