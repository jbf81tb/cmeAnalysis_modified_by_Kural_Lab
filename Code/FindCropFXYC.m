clear beg mid
index=1;
for i=1:length(fxyc(:,1))
    if fxyc(i,3)<63 || fxyc(i,3)>435 || fxyc(i,2)<38 || fxyc(i,2)>430
        beg(index)=fxyc(i,5);
        mid(index)=fxyc(i,6);
        index=index+1;
    end
end