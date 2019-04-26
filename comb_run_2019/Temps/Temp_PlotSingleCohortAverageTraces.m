function Temp_PlotSingleCohortAverageTraces(AC,varargin)

if length(varargin)==0
    N=1;
else
    N=varargin{1};
    if length(varargin)>1
        Ls=varargin{2};
    else
        Ls=0:10:50;
    end
end

NBins=100;

lens=zeros(1,length(AC));
for i=1:length(AC)
    lens(i)=length(AC{i});
end
for i=1:length(Ls)-1
    used=find(lens>=Ls(i) & lens<Ls(i+1));
    ACoh{i}=AC(used);
    Num(i)=length(used);
end
i=3;
NS=25;
NT=length(ACoh{i});
    SCoh{i}=zeros(NS,NBins);
    figure
    for i2=1:50 %length(ACoh{i})
        %SuperSubplot(i2)
        STrace=ScottifyTrace(ACoh{i}{i2}/N,NBins);
        plot(STrace)
        hold on
        SCoh{i}(i2,:)=STrace;
    end
    Cs{i}=mean(SCoh{i});
    SDs{i}=std(SCoh{i});
    SEs{i}=std(SCoh{i})/sqrt(Num(i));
    figure
    plot(Cs{i})

