clear all;
load('FlyFullfxyc4.mat');
fade=.5;
mode=2;
[a,b,c]=size(fxyc);
Endsfxyc=[];
newfile='FlyEndsPoints6.tif'; %File for traced movie to be saved to
file='FlyStack2TAv.tif'; %File to trace on
num=0;
Thresh=175;
if 1==1 %use EndDecision function to find ends
    index=1;
    for i=1:c
        slots=find(fxyc(:,5,c));
        clear Ints
        for j=1:length(slots)
            Ints(j)=fxyc(slots(j),5,i);
        end
        [BegPL,FinPL]=EndDecision(Ints,fade,Thresh);
        [d,e]=size(BegPL);
        for j=1:d
            for k=1:BegPL(j,2)
              
                Endsfxyc(k,:,index)=fxyc(slots(BegPL(j,1)+k-1),:,i);
                Endsfxyc(k,4,index)=1;
                
            end
            index=index+1;
        end
        [d,e]=size(FinPL);
        for j=1:d
            for k=1:FinPL(j,2)
                Endsfxyc(k,:,index)=fxyc(slots(FinPL(j,1)+k-1),:,i);
                Endsfxyc(k,4,index)=2;
                
            end
            index=index+1;
        end
    end
end
if mode==2
    ColorEndsAsPoints(Endsfxyc,file,newfile);
end
save FlyEndsfxyc.mat Endsfxyc