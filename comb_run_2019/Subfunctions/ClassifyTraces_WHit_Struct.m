function [C2,B,E,F12,varargout]=ClassifyTraces_WHit_Struct(fxycS,movie,framegap)

NBins=20;
medInorm=0;


[Data,used]=FXYCStruct2Data(movie,fxycS,framegap);
[X,yBeg,yEnd]=ConstructFeatures_SAV_DifMovs(Data,NBins,medInorm);

[C,B,E,F1]=CategorizeExample_new_Noload(X);
C=CategorizeWHit(C,[Data.Hits]);
N=length(fxycS);

C2=zeros(1,N)+4;
C2(used)=C;
F12=zeros(1,N);
F12(used)=F1;

varargout{1}=Data;
varargout{2}=used;