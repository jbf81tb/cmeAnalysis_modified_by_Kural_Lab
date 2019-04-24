function [Splits,traces,varargout]=FindBestMultiSplit_WH(Itrace,Hit,framegap,F1min,minL)

[C,~,~,Forig]=CategorizeExample_WH_Wrapper(Itrace,Hit,framegap);  %alter categorization based on trace hitting end of movie
[Split,~,~,~]=FindBestSplit_Exp2(Itrace,framegap,F1min,minL);
if Split<=minL || Split>=length(Itrace)-minL+1
    Split=0;
end
if Split~=0
    trace{1}=Itrace(1:Split);
    trace{2}=Itrace(Split+1:end);
    switch(Hit)
        case 0
            SH1=0; SH2=0;
        case 1
            SH1=1; SH2=0;
        case 2
            SH1=0; SH2=2;
        case 3
            SH1=1; SH2=2;
    end
    [Splits1,trace{1},~,Fnew{1},Cnew{1}]=FindBestMultiSplit_WH(trace{1},SH1,framegap,F1min,minL);
    [Splits2,trace{2},~,Fnew{2},Cnew{2}]=FindBestMultiSplit_WH(trace{2},SH2,framegap,F1min,minL);
    Splits2=Splits2+Split;  %Want to have final Splits vector in terms of position in original vector
    traces=[trace{1} , trace{2}];
    Fs=[Fnew{1} Fnew{2}];
    Cs=[Cnew{1} Cnew{2}];
    Splits=[Splits1 Splits2];
else
    traces={Itrace};
    Fs=Forig;
    Splits=0;
    Cs=C;
end
varargout{1}=Forig;
varargout{2}=Fs;
varargout{3}=Cs;