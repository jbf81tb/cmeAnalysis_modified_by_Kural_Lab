function fxyc=CalculateHWHM(path,movie,frames,plane) %Only works for up to 5 planes because of the beginning
maxwindow=4;
load(path)
if plane==1
    fxyc=fxyc1;
end
if plane==2
    fxyc=fxyc2;
end
if plane==3
    fxyc=fxyc3;
end
if plane==4
    fxyc=fxyc4;
end
if plane==5
    fxyc=fxyc5;
end
[a,b,c]=size(fxyc);

ext=ceil((maxwindow+1)/2);
IM=imread(movie,'Index',1);
[A,B]=size(IM);
index=1;
for i=1:a
    for j=1:c
        if fxyc(i,1,j)>0
            used(index,1)=i;
            used(index,2)=j;
            index=index+1;
        end
    end
end
[num,~]=size(used);
for i=1:num
    f(i)=fxyc(used(i,1),1,used(i,2));
    xf(i)=fxyc(used(i,1),2,used(i,2));
    yf(i)=fxyc(used(i,1),3,used(i,2));
end
h=waitbar(0,'Calculating HWHM');
for j=1:frames
    waitbar(j/frames)
    inds=find(f==j);
    IM=imread(movie,'Index',j);
    for i=1:length(inds)
        x=xf(inds(i));
        y=yf(inds(i));
        sum=zeros(maxwindow);
        if x>ext && x<B-ext && y>ext && y<A-ext
            for wind=1:maxwindow
                window=wind*2-1;
                middle=floor((window+1)/2);
                for k1=1:window
                    for k2=1:window
                        if k1==1 || k1==window || k2==1 || k2==window
                        sum(wind)=sum(wind)+IM(y+k1-middle,x+k2-middle);
                        end
                    end
                end
            end
        end
        HM=((sum(1)-sum(4)/16)/2+sum(4)/16); %RHS is HM accounting for a background at a radius of 3
        if sum(2)/8<=HM
            HWHM=(HM-sum(1))/(sum(2)/8-sum(1)); %Find where the line between the average int at the center and r=1 crosses HM
        else
            if sum(3)/16<=HM
                HWHM=1+(HM-sum(2)/8)/(sum(3)/16-sum(2)/8);
            else
                if sum(4)/24<=HM
                    HWHM=2+(HM-sum(3)/16)/(sum(4)/24-sum(3)/16);
                else
                HWHM=3;
                end
            end
        end
        fxyc(used(inds(i),1),9,used(inds(i),2))=HWHM;
    end
end
close(h)