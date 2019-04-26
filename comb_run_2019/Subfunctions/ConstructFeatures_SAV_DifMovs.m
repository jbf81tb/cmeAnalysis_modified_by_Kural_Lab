function [X,yBeg,yEnd]=ConstructFeatures_SAV_DifMovs(Data,NBins,medInorm)

%NBins=100;
X=zeros(length(Data),NBins+2);
yBeg=zeros(length(Data),1);
yEnd=zeros(length(Data),1);
for i=1:length(Data)
    X(i,1)=1;
    trace=Data(i).A;
    X(i,2)=length(trace);
    STrace=ScottifyTrace_Averaged(trace,NBins);
    X(i,3:end)=STrace;
    if isfield(Data,'Dec')
        D=Data(i).Dec;
        if D==1
            yBeg(i)=1;
            yEnd(i)=0;
        end
        if D==2
            yBeg(i)=0;
            yEnd(i)=1;
        end
        if D==3
            yBeg(i)=1;
            yEnd(i)=1;
        end
        if D==4
            yBeg(i)=0;
            yEnd(i)=0;
        end
    end
end
LN=60./[Data.framegap];
if medInorm
    X(:,3:end)=X(:,3:end)./[Data.medI].';
else
    X(:,3:end)=X(:,3:end)/200;
end
X(:,2)=X(:,2)./LN.';

