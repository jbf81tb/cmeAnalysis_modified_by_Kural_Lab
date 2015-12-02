[a,b]=size(TraceX);
% keep=zeros(1,a);
% for i=1:a
%     if ~isempty(find(TraceX,1,'first'))
%         keep(i)=1;
%     end
% end
% index=1;
% for i=1:a
%     if keep(i)==1
%         TraceXt(index,:)=TraceX(i,:);
%         TraceYt(index,:)=TraceY(i,:);
%         TraceZt(index,:)=TraceZ(i,:);
%         TraceINTt(index,:)=TraceINT(i,:);
%         index=index+1;
%     end
% end
for i=1:a
    for j=1:b
        if j>find(TraceX(i,:),1,'first') && j<find(TraceX(i,:),1,'last') && TraceX(i,j)==0
            done=false;
            prev=1;
            while done==false
                if TraceX(i,j-prev)~=0
                    TraceX(i,j)=TraceX(i,j-prev);
                    TraceY(i,j)=TraceY(i,j-prev);
                    TraceZ(i,j)=TraceZ(i,j-prev);
                    TraceINT(i,j)=TraceINT(i,j-prev);
                    done=true;
                end
                prev=prev+1;
            end
        end
    end
end
% TraceX=TraceXt;
% TraceY=TraceYt;
% TraceZ=TraceZt;
% TraceINT=TraceINTt;
save Traces5.mat TraceX TraceY TraceZ TraceINT;