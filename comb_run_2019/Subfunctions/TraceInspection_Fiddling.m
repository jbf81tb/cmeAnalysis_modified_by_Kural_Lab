clear
%file='E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\orig_movies\cell006_Stack1.mat';
%movie='E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\cell006_Stack1.tif';
% file='E:\CME Superfolder\CME Data\190111_Analysis\100ms\orig_movies\cell_C1.mat';
% movie='E:\CME Superfolder\CME Data\190111_Analysis\100ms\orig_movies\cell_C1.tif';
% file='E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell005_C1.mat';
% movie='E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell005_C1.tif';
file='E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell008_C1.mat';
movie='E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell008_C1.tif';
framegap=1;
Data=FXYC2Data(movie,file,framegap);
NBins=20;
% [X,yBeg,yEnd]=ConstructFeatures(Data,NBins,framegap);
[X,yBeg,yEnd]=ConstructFeatures_SAV_DifMovs(Data,NBins,0);

%%

for i=1:length(imfinfo(movie))
    IM(:,:,i)=imread(movie,'Index',i);
end
%%
framegap=60;
MedI=1;

load(file)
used0=find([Data.CMED]);
I=ceil(rand*length(used0));
T=Data(used0(I)).T;
CME=Data(used0(I)).CMED;
trace=Threshfxyc(:,:,T);
used=find(trace(:,1));
trace=trace(used,:);
C=CategorizeExample_new(X(used0(I),:));
tit=strcat('CMED=',num2str(CME),'; MLD=',num2str(C));
TraceInspection(trace,IM,tit,1:20,X(used0(I),3:end));
% figure
% plot(X(used0(I),3:end))