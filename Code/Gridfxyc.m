clear all
for i=1:16
    for j=1:308
        
            Endsfxyc(j,1,i)=j;
            Endsfxyc(j,2,i)=ceil(i/4)*100;
            if mod(i,4)~=0
                Endsfxyc(j,3,i)=mod(i,4)*100;
            else
                Endsfxyc(j,3,i)=400;
            end
            Endsfxyc(j,5,i)=300;
        
    end
end
save FlyEndsGrid.mat Endsfxyc