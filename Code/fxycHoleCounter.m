[A,B,C]=size(fxyc);
num=0;
for i=1:C
    if ~isempty(nonzeros(fxyc(:,2,i)))
        start=find(fxyc(:,2,i),1,'first');
        finish=find(fxyc(:,2,i),1,'last');
        for j=start(1):finish(1)
            if fxyc(j,2,i)==0
                num=num+1;
            end
        end
    end
end
num