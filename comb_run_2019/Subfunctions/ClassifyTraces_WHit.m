function [C2,B,E,F12,varargout]=ClassifyTraces_WHit(file,movie,framegap)

NBins=20;
medInorm=0;

if ischar(file)
    load(file,'Threshfxyc')
else
    Threshfxyc=file;
end

[Data,used]=FXYC2Data(movie,file,framegap);
[X,yBeg,yEnd]=ConstructFeatures_SAV_DifMovs(Data,NBins,medInorm);

[C,B,E,F1]=CategorizeExample_new(X);
C=CategorizeWHit(C,[Data.Hits]);
N=length(Threshfxyc(1,1,:));
notused=~ismember(1:N,used);

C2=zeros(1,N)+4;
C2(used)=C;
F12=zeros(1,N);
F12(used)=F1;

%Needs to take into account Data.Hits to classify 5s, 6s, and 7s
varargout{1}=Data;