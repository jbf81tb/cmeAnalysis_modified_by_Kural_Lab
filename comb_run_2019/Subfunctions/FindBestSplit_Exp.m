function [Split,varargout]=FindBestSplit_Exp(Itrace,framegap,F1min)
%Tries splitting trace into two sections, if it can split trace into 2 3s,
%returns the best splitpoint, else returns 0
Best.i=0;
Best.Fs=[0 0];
Best.C=[0 0];

[CO,BO,EO,Forig]=CategorizeExample_Wrapper(Itrace,framegap);
NBins=20;
X=zeros(2,22);
for i=2:length(Itrace)-2
    t{1}=Itrace(1:i);
    t{2}=Itrace(i+1:end);
    for i2=1:2
        STrace{i2}=ScottifyTrace_Averaged(t{i2},NBins);
        X(i2,1)=1;
        X(i2,2)=length(t{i2});
        X(i2,3:end)=STrace{i2};
    end
    LN=60/framegap;
    X(:,3:end)=X(:,3:end)/200;
    X(:,2)=X(:,2)/LN;
    [C,B,E,F1]=CategorizeExample_new_Noload(X);
    used=find(C==3);
    F3=F1(used);
    if (~isempty(used)) && (max(F1)>Forig || min(F1)>F1min(1) || max(F1)>F1min(2)) %If one of the traces is full, compare F1 score        
        if (C(1)==3 && C(2)==3) %If both are full, compare sum of F1s
            if (Best.C(1)~=3 || Best.C(2)~=3) || sum(F1)>sum(Best.Fs)
                Best.i=i;
                Best.Fs=F1;
                Best.C=C;
            end
        else  %If one is not full, compare F1 of good one (prefer traces with both full)
            if (Best.C(1)~=3 || Best.C(2)~=3) && max(F3)>max(Best.Fs)
                Best.i=i;
                Best.Fs=F1;
                Best.C=C;
            end
        end
    end
%     if (min(B(2),E(1))>.5) && (C(1)~=4 || C(2)~=4) && ~(CO==3 || C(1)==3 || C(2)==3) %If one of the traces is not full, compare best end score
%         if min(F1)>min(Best.Fs) %Ignore this for now--too many false
%         positives
%             Best.i=i;
%             Best.Fs=F1;
%             Best.C=C;
%         end
%     end
end
Split=Best.i;
varargout{1}=Forig;
varargout{2}=Best.Fs;
varargout{3}=Best.C;