function LengthP=ColorTracesbyLength(fxyc,file,newfile) %adds colored spots to tif stack (named file--rewrites it in a file named newfile) at desired locations--fzzzmmmc is a nzzz4 matrizzz with the n spots--column 1 frame,column 2 zzz position, column 3 mmm position, column 4 color (1 for green, 2 for red)

frames=length(imfinfo(file));
h=waitbar(0,'Coloring Images');
A=imread(file,'Index',1);
[n,m]=size(A);
maxtime=length(fxyc(:,1,1));
lengths=[];
for i=1:length(fxyc(1,1,:))
    if (fxyc(1,4,i)>0 && fxyc(1,4,i)<4) || (fxyc(1,4,i)>4 && fxyc(1,4,i)<7)
    lengths=[lengths length(find(fxyc(:,1,i)))];
    end
end
for i=1:20
    LengthP(i)=prctile(lengths,i*5);
end
MaxLength=prctile(lengths,80);
MinLength=10;
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
        L=length(find(fxyc(:,1,inds(j))));
        %L=max(L-MinLength,0);
        pL=find(LengthP>=L,1,'first');
        if x~=0 && y~=0
        if (c>0 && c<4) || (c>4 && c<7)
            B(y,x,1)=6000;
            B(y,x,2)=pL(1)/20*6000;
            B(y,x,3)=0;
        end
       
%         if c==8
%             B(y,x,1)=0;
%             B(y,x,2)=0;
%             B(y,x,3)=6000;
%         end
        end
    end
    for time=2:maxtime
        inds=find(fxyc(time,1,:)==i);
        for j=1:length(inds)
            t=time;
            c=fxyc(time,4,inds(j));
            
            Tlength=length(find(fxyc(:,1,inds(j))));
            while t>1  %Draw lines to all previous points on trace
                p2=[fxyc(t,3,inds(j)) fxyc(t,2,inds(j))];
                p1=[fxyc(t-1,3,inds(j)) fxyc(t-1,2,inds(j))];
                int=fxyc(t,5,inds(j));
                L=length(find(fxyc(:,1,inds(j))));
                %L=max(L-MinLength,0);
                pL=find(LengthP>=L,1,'first');
                p=PointsInLine(p1,p2);
                if p1(1)~=0 && p1(2)~=0 && p2(1)~=0 && p2(2)~=0
                for k=2:length(p(:,1))
                    y=p(k,1);
                    x=p(k,2);
                    if (c>0 && c<4) || (c>4 && c<7)
                        B(y,x,1)=6000;
                        B(y,x,2)=pL(1)/20*6000;
                        B(y,x,3)=0;
                    end
                    
%                     if c==8
%                         B(y,x,1)=0;
%                         B(y,x,2)=0;
%                         B(y,x,3)=6000;
%                     end
                   
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