function [IMat,CMat]=InitiationAnalysis(fxyc) %Right now it records all of the traces, not just the ones designated as "real"

[A,B,C]=size(fxyc);
IMat=[];
CMat=[];
for i=1:C 
    used=find(fxyc(:,1,i));
    used2=find(fxyc(:,5,i));
    if ~isempty(used)
        c=fxyc(used(1),4,i);
        if (c==1 || c==2 || c==3 || c==4 || c==5) && length(used2)>=7 %Look for and record initiations
            beginning=find(fxyc(:,1,i)==min(nonzeros(fxyc(:,1,i))));
            vect=[fxyc(beginning(1),1,i) fxyc(beginning(1),2,i) fxyc(beginning(1),3,i)];
            IMat=[IMat ; vect];
        end
        if (c==1 || c==2 || c==3 || c==4 || c==6) && length(used2)>=7 %Look for and record conclusions
            finish=find(fxyc(:,1,i)==max(fxyc(:,1,i)));
            vect=[fxyc(finish(1),1,i) fxyc(finish(1),2,i) fxyc(finish(1),3,i)];
            CMat=[CMat ; vect];
        end
    end
end