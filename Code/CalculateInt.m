function int=CalculateInt(IM,x,y) %Calculates intensity at point (x,y) in image

window=5; %DO NOT CHANGE WITHOUT CONSIDERING THE BELOW
bigwindow=9;
middle=floor((window+1)/2);
ext=ceil((bigwindow+1)/2);
bigmiddle=floor((bigwindow+1)/2);
[A,B]=size(IM);
sums=0;
maxint=0;
background=0;
if x>ext && x<B-ext && y>ext && y<A-ext
    sums=zeros(window);
    bigsum=zeros(bigwindow);
    num=0;
    for k1=1:window
        for k2=1:window
            if k1*k2~=1 && k1*k2~=window && k1*k2~=window^2 %exclude corners--WILL NOT WORK FOR ALL WINDOW VALUES
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
int=maxint-background;

