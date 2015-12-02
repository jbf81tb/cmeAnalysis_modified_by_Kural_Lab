function [TraceX,TraceY,TraceINT]=TraceFiller(TraceX,TraceY,TraceINT)
[A,B]=size(TraceX);
NewTraceX=[];
h=waitbar(0,'Sorting Traces')
for i=1:A
    waitbar(i/A)
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
                        found=true;
                    end
                    k=k+1;
                end
            end
        end
        if ~isempty(NewTraceX)
            NewTraceX=[NewTraceX;TraceX(i,:)];
            NewTraceY=[NewTraceY;TraceY(i,:)];
            NewTraceINT=[NewTraceINT;TraceINT(i,:)];
        else
            NewTraceX=TraceX(i,:);
            NewTraceY=TraceY(i,:);
            NewTraceINT=TraceINT(i,:);
        end
    end
end
close(h)
TraceX=NewTraceX;
TraceY=NewTraceY;