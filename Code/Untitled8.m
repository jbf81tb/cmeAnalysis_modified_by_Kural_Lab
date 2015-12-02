clear num
for i=1:length(TraceX(:,1))
    num(i)=length(find(TraceX(i,:)));
end