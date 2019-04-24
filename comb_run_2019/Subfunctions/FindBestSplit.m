function [Split,varargout]=FindBestSplit(Itrace,framegap,F1min)
%Tries splitting trace into two sections, if it can split trace into 2 3s,
%returns the best splitpoint, else returns 0
Best.i=0;
Best.Fs=[0 0];
Best.C=[0 0];
[C,BO,BE,Forig]=CategorizeExample_Wrapper(Itrace,framegap);
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
    [C,B,E,F1]=CategorizeExample_new(X);
    if (max(F1)>=Forig) && (C(1)~=4 || C(2)~=4)
        if min(F1)>min(Best.Fs)
            Best.i=i;
            Best.Fs=F1;
            Best.C=C;
        end
    end
end
Split=Best.i;
varargout{1}=Forig;
varargout{2}=Best.Fs;
varargout{3}=Best.C;