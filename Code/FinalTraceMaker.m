function [TraceX,TraceY,TraceINT]=FinalTraceMaker(totalmiddle,SolTwo,middleindex2trace,middleindex2frame,traceX,traceY,traceINT)
[TraceNum,frames]=size(traceX);
maxmergeduration=8;
split=zeros(TraceNum,TraceNum);
merge=zeros(TraceNum,TraceNum);

for i=1:totalmiddle
    for j=1:TraceNum
        if SolTwo(i+TraceNum,j)==1 %show a split occured
            split(j,middleindex2trace(i))=middleindex2frame(i); %split(i,j,k) denotes trace i split from trace j on frame k
     
        end
    end
end
index=1;
for j=1:totalmiddle
    for i=1:TraceNum
        if SolTwo(i,j+TraceNum)==1 %show a merge occured
            merge(i,middleindex2trace(j))=middleindex2frame(j); %merge(i,j,k) denotes trace i merged with trace j on frame k
            
           
        end
    end
end
for i=1:TraceNum
    actual(i)=i;
end
for i=1:TraceNum
    for j=1:TraceNum
        if SolTwo(i,j)==1 %glue starts and ends of traces together
            for k=1:frames
                if traceX(actual(j),k)~=0
                    traceX(actual(i),k)=traceX(actual(j),k);
                    traceY(actual(i),k)=traceY(actual(j),k);
                    traceINT(actual(i),k)=traceINT(actual(j),k); %copy trace j onto the end of trace i
                    traceX(actual(j),k)=0;
                    traceY(actual(j),k)=0;
                    traceINT(actual(j),k)=0; %erase trace j   
                end
                
            end
            fixes=find(actual==actual(j));
            for m=1:length(fixes)
                actual(fixes(m))=actual(i);
            end
            
            linktofix=find(middleindex2trace==actual(j)); %to be fixed later if needed
            for m=1:length(linktofix)
                 middleindex2trace(linktofix(m))=i; %fix middleindex2trace links
            end
            
            for m=1:TraceNum
                for n=1:frames
                    
                        if split(m,j)==n
                           split(m,actual(j))=n; %fix split links
                           split(m,j)=0;
                        end
                    
                end
            end
            for m=1:TraceNum
                for n=1:frames
                    
                        if merge(m,j)==n
                            merge(m,actual(j))=n; %fix merge links
                            merge(m,j)=0;
                        end
                    
                end
            end
            for m=1:TraceNum
                for n=1:frames
                    
                        if merge(j,m)==n
                            merge(actual(j),m)=n; %fix final merge links
                            merge(j,m)=0;
                        end
                    
                end
            end
        end
    end
end
for i=1:TraceNum
    for j=1:TraceNum
        for k=1:frames
            
            if merge(i,j)==k
                for m=1:min(maxmergeduration,frames-k)
                    if length(find(split(:,j)==k+m))==1 %merge happened, then split happened shortly after
                        traceend=find(split(:,j)==k+m);
                        for n=1:frames
                            if traceX(actual(traceend),n)~=0
                                traceX(actual(i),n)=traceX(actual(traceend),n);
                                traceY(actual(i),n)=traceY(actual(traceend),n);
                                traceINT(actual(i),n)=traceINT(actual(traceend),n); %copy trace j onto the end of trace i
                                traceX(actual(traceend),n)=0;
                                traceY(actual(traceend),n)=0;
                                traceINT(actual(traceend),n)=0; %erase trace j
                                
                            end
                        end
                        fixes=find(actual==actual(traceend));
                        for m=1:length(fixes)
                            actual(fixes(m))=actual(i);
                        end
                        for n=1:m
                            traceX(actual(i),n)=traceX(actual(j),n+k);
                            traceY(actual(i),n)=traceY(actual(j),n+k);
                            traceINT(actual(i),n)=traceINT(actual(j),n+k); %copy trace j onto the end of trace i
                        end
                        break
                    end
                    if m==maxmergeduration %no split was found so just copy the first shared frames
                        for n=1:m
                            traceX(actual(i),n)=traceX(actual(j),n+k);
                            traceY(actual(i),n)=traceY(actual(j),n+k);
                            traceINT(actual(i),n)=traceINT(actual(j),n+k); 
                        end
                    end
                end
            end
            
        end
    end
end
%Can add extra split frames on unused split later
TraceX=traceX;
TraceY=traceY;
TraceINT=traceINT;