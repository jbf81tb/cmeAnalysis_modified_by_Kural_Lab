function [C,varargout]=CategorizeExample_WH_Wrapper(Itrace,Hit,framegap)

NBins=20;
X=zeros(1,22);
STrace=ScottifyTrace_Averaged(Itrace,NBins);
i2=1;
X(i2,1)=1;
X(i2,2)=length(Itrace);
X(i2,3:end)=STrace;
LN=60/framegap;
X(:,3:end)=X(:,3:end)/200;
X(:,2)=X(:,2)/LN;
[C,varargout{1},varargout{2},varargout{3}]=CategorizeExample_new_WH(X,Hit);