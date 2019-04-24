function varargout=Temp_BestSplitPlot(Itrace,framegap,varargin)

if length(varargin)==0
    P=1;
else
    P=varargin{1};
end
[Split,Forig,Fnew]=FindBestSplit(Itrace,framegap,0);
Strace{1}=[];
Strace{2}=[];
if Split~=0
    Strace{1}=Itrace(1:Split);
    Strace{2}=Itrace(Split+1:end);
    ST{1}=1:Split;
    ST{2}=Split+1:length(Itrace);
    if P
        figure
        plot(Itrace+20,'b')
        hold on
        plot(ST{1},Strace{1},'g')
        hold on
        plot(ST{2},Strace{2},'r')
        L{1}=num2str(Forig);
        L{2}=num2str(Fnew(1));
        L{3}=num2str(Fnew(2));
    end
else
    if P
        plot(Itrace+20,'b')
        L{1}=num2str(Forig);
    end
end
if P
    legend(L)
end
varargout{1}=Strace;