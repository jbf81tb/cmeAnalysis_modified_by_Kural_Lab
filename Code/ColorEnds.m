function ColorEnds(fxyc,file,newfile)
%Same as ColorSpots, but only color beginnings (green) and ends (red)

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
        x=fxyc(1,2,inds(j));
        y=fxyc(1,3,inds(j));
        c=fxyc(1,4,inds(j));
        if c==2
            B(y,x,1)=3000;
            B(y,x,2)=0;
            B(y,x,3)=0;
        end
        if c==1
            B(y,x,1)=0;
            B(y,x,2)=3000;
            B(y,x,3)=0;
        end
        if c==3
            B(y,x,1)=0;
            B(y,x,2)=3000;
            B(y,x,3)=0;
        end
    end
    for time=2:maxtime
        inds=find(fxyc(time,1,:)==i);
        for j=1:length(inds)
            t=time;
            c=fxyc(time,4,inds(j));
            
            Tlength=length(find(fxyc(:,1,inds(j))));
            Last=find(fxyc(:,1,inds(j)),1,'last');
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
                        B(y,x,1)=0;
                        B(y,x,2)=3000;
                        B(y,x,3)=0;
                    end
                    if c==3 && t<=3 && time<=3
                        B(y,x,1)=0;
                        B(y,x,2)=3000;
                        B(y,x,3)=0;
                    end
                    if c==3 && t>=Last(1)-2 && time>=Last(1)-2
                        B(y,x,1)=3000;
                        B(y,x,2)=0;
                        B(y,x,3)=0;
                    end
                end
                t=t-1;
            end
        end
    end
    imwrite(B,newfile,'Writemode','append','Compression','none')
    waitbar(i/frames)
end
close(h);