[a,b]=size(num);
inc=zeros(1,10);
for i=1:a
    for n=1:10
        inc(n)=inc(n)+length(find(num(i,:)==n));
    end
end