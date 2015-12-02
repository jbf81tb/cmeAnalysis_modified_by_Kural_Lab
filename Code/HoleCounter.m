[A,B]=size(TraceX);
num=0;
for i=1:A
    if ~isempty(nonzeros(TraceX(i,:)))
        start=find(TraceX(i,:),1,'first');
        finish=find(TraceX(i,:),1,'last');
        for j=start(1):finish(1)
            if TraceX(i,j)==0
               num=num+1;
               break
            end
        end
    end
end
num