function [TraceX,TraceY,TraceZ,TraceINT]=HoleFiller(TraceX,TraceY,TraceZ,TraceINT)
[A,~]=size(TraceX);
for i=1:A
    if ~isempty(nonzeros(TraceX(i,:)))
        start=find(TraceX(i,:),1,'first');
        finish=find(TraceX(i,:),1,'last');
        for j=start(1):finish(1)
            if TraceX(i,j)==0
                found=false;
                k=1;
                while found==false
                    if TraceX(i,j-k)~=0
                        TraceX(i,j)=TraceX(i,j-k);
                        TraceY(i,j)=TraceY(i,j-k);
                        TraceZ(i,j)=TraceZ(i,j-k);
                        TraceINT(i,j)=TraceINT(i,j-k);
                        found=true;
                    end
                    k=k+1;
                end
            end
        end
    end
end