function [Beg,Fin,varargout]=FindBestCrop(Itrace,framegap)

Best.i=[0 0];
Best.Fs=0;
[C,~,~,Fo]=CategorizeExample_Wrapper(Itrace,framegap);
Forig=0;
if C==3
    Forig=Fo;
    Best.Fs=Forig;
    Best.i=[1 length(Itrace)];
end
for ibeg=1:length(Itrace)-1
    for ifin=ibeg+1:length(Itrace)
        [C,~,~,F]=CategorizeExample_Wrapper(Itrace(ibeg:ifin),framegap);
        if C==3 && F>Best.Fs
            Best.i=[ibeg ifin];
            Best.Fs=F;
        end
    end
end
Beg=Best.i(1);
Fin=Best.i(2);
varargout{1}=Forig;
varargout{2}=Best.Fs;

