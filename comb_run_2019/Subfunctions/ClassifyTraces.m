function [C,B,E,F1,varargout]=ClassifyTraces(file,movie)

NBins=20;
medInorm=0;

Data=FXYC2Data(movie,file,1,4);
[X,yBeg,yEnd]=ConstructFeatures_SAV_DifMovs(Data,NBins,medInorm);

[C,B,E,F1]=CategorizeExample_new(X);
%Needs to take into account Data.Hits to classify 5s, 6s, and 7s
varargout{1}=Data;