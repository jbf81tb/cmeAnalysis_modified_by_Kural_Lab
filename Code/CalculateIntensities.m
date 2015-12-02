function fxyc=CalculateIntensities(path,movie,frames)
%Manual intensities save to fxyc slot 8
window=5;%DO NOT CHANGE WITHOUT CONSIDERING THE BELOW
bigwindow=9;
load(path)
fxyc=Threshfxyc;
[a,b,c]=size(fxyc);
middle=floor((window+1)/2);
ext=ceil((bigwindow+1)/2);
bigmiddle=floor((bigwindow+1)/2);
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
for j=1:frames
    inds=find(f==j);
    IM=imread(movie,'Index',j);
    for i=1:length(inds)
        x=xf(inds(i));
        y=yf(inds(i));
        maxint=0;
        background=0;
        if x>ext && x<B-ext && y>ext && y<A-ext
            sums=zeros(window);
            bigsum=zeros(bigwindow);
            num=0;
            for k1=1:window
                for k2=1:window
                    if k1*k2~=1 && k1*k2~=window && k1*k2~=window^2 %subtracts corners of box--WILL NOT WORK FOR ARBITRARY WINDOW VALUE
                        sums(k1,k2)=IM(y+k1-middle,x+k2-middle);
                        num=num+1;
                    end
                end
            end
            for k1=1:bigwindow
                for k2=1:bigwindow
                    bigsum(k1,k2)=IM(y+k1-bigmiddle,x+k2-bigmiddle);
                end
            end
            maxint=sum(sum(sums));
            maxint=maxint/num;
            background=min(min(mean(bigsum,1)),min(mean(bigsum,2)));
        end
        fxyc(used(inds(i),1),8,used(inds(i),2))=maxint-background;
    end
end
