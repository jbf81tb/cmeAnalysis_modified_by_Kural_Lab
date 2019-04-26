function [C2,B2,E2,F12,varargout]=ClassifyTraces_WHit_Struct_TIRF(fxycS,movie,framegap)

NBins=20;
medInorm=1;  %Turn medInorm on because intensity is significantly different
R=7; %Bigger averaging are for TIRF camera

[Data,used]=FXYCStruct2Data_Minimal(movie,fxycS,framegap,7,R);
medI=median([Data.A]);
for i=1:length(Data)
    Data(i).medI=medI;
end
[X,yBeg,yEnd]=ConstructFeatures_SAV_DifMovs(Data,NBins,medInorm);

[C,B,E,F1]=CategorizeExample_new(X);
C=CategorizeWHit(C,[Data.Hits]);
N=length(fxycS);

C2=zeros(1,N)+4;
C2(used)=C;
F12=zeros(1,N);
F12(used)=F1;
B2=zeros(1,N);
B2(used)=B;
E2=zeros(1,N);
E2(used)=E;

varargout{1}=Data;
varargout{2}=used;