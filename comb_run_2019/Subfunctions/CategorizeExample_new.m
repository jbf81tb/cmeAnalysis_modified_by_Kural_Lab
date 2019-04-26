function [C,varargout]=CategorizeExample_new(X)

%load('190107_LRThetas.mat')
%load('190107_LRThetas_NBins10.mat')
load('190212_LRThetas_NBins20.mat','ThetaB','ThetaE')
%[a,~]=size(Xv);

B=sigmoid(ThetaB.'*X.');
E=sigmoid(ThetaE.'*X.');
SB=B>.5;
SE=E>.5;

C=CombinedCategory(SB,SE);

varargout{1}=B;
varargout{2}=E;
varargout{3}=2*B.*E./(B+E);