frames=401;
sum=zeros(1,frames);
total=zeros(1,frames);
av=zeros(1,frames);
for i=2:frames+1
    for j=2:36
        if A(i,j)~=0
            for k=1:A(i,j)/3
                if i-1+k-1<=frames
                sum(i-1+k-1)=sum(i-1+k-1)+A(i,j);
                total(i-1+k-1)=total(i-1+k-1)+1;
                end
            end
        end
    end
end
for i=1:frames
    if total(i)~=0
        av(i)=sum(i)/total(i);
    else
        av(i)=0;
    end
end