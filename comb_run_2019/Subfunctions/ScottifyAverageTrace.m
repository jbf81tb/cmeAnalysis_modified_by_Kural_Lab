function [Av,SD,varargout]=ScottifyAverageTrace(traces,NBins,plot,fig)

N=length(traces);
STrace=zeros(N,NBins);
STraceC=cell(1,N);
for i=1:N
    STrace(i,:)=ScottifyTrace(traces{i},NBins);
    STraceC{i}=STrace(i,:).';
end
Av=mean(STrace);
SD=std(STrace);%/sqrt(N);
if plot
    if fig
        figure
    end
    Obj=PlotShadedErrorBars(1:NBins,Av,SD,'b','b');
end
varargout{1}=STrace;
varargout{2}=STraceC;