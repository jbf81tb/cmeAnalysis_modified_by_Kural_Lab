function p=PointsInLine(p1,p2)

d=sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
for i=1:floor(d*5)
    q(i,1)=p1(1)+(p2(1)-p1(1))*i/(d*5);
    q(i,2)=p1(2)+(p2(2)-p1(2))*i/(d*5);
end
p(1,:)=p2;
p(2,:)=p1;
for i=1:floor(d*5)
    A=find(p(:,1)==floor(q(i,1)));
    found=false;
    for j=1:length(A)
        if p(A(j),2)==floor(q(i,2))
            found=true;
        end
    end
    if ~found
        p=[p;floor(q(i,:))];
    end
end