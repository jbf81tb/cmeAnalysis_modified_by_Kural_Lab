DataTrain=struct([]);
DataVal=struct([]);
DataTest=struct([]);
trn=120;
val=36;
tst=36;

load('E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\cell006_Stack1_ManualDecisions_st.mat')
file='E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\orig_movies\cell006_Stack1.mat';
movie='E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\cell006_Stack1.tif';
Data=Decisions2Data(Decisions,movie,file,3);
P=randperm(length(Data));
DataTrain=[DataTrain,Data(P(1:trn))];
DataVal=[DataVal,Data(P(1+trn:trn+val))];
DataTest=[DataTest,Data(P(1+trn+val:trn+val+tst))];

load('E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell008_C1_ManualDecisions.mat')
file='E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell008_C1.mat';
movie='E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell008_C1.tif';
Data=Decisions2Data(Decisions,movie,file,1);
P=randperm(length(Data));
DataTrain=[DataTrain,Data(P(1:trn))];
DataVal=[DataVal,Data(P(1+trn:trn+val))];
DataTest=[DataTest,Data(P(1+trn+val:trn+val+tst))];

load('E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell015_C1_ManualDecisions.mat')
file='E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell015_C1.mat';
movie='E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell015_C1.tif';
Data=Decisions2Data(Decisions,movie,file,1);
P=randperm(length(Data));
DataTrain=[DataTrain,Data(P(1:trn))];
DataVal=[DataVal,Data(P(1+trn:trn+val))];
DataTest=[DataTest,Data(P(1+trn+val:trn+val+tst))];

load('E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell005_C1_ManualDecisions.mat')
file='E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell005_C1.mat';
movie='E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell005_C1.tif';
Data=Decisions2Data(Decisions,movie,file,1);
P=randperm(length(Data));
DataTrain=[DataTrain,Data(P(1:trn))];
DataVal=[DataVal,Data(P(1+trn:trn+val))];
DataTest=[DataTest,Data(P(1+trn+val:trn+val+tst))];

load('E:\CME Superfolder\CME Data\190111_Analysis\100ms\orig_movies\cell_C1_ManualDecisions.mat')
file='E:\CME Superfolder\CME Data\190111_Analysis\100ms\orig_movies\cell_C1.mat';
movie='E:\CME Superfolder\CME Data\190111_Analysis\100ms\orig_movies\cell_C1.tif';
Data=Decisions2Data(Decisions,movie,file,1);
P=randperm(length(Data));
DataTrain=[DataTrain,Data(P(1:trn))];
DataVal=[DataVal,Data(P(1+trn:trn+val))];
DataTest=[DataTest,Data(P(1+trn+val:trn+val+tst))];

load('E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell010_C1_ManualDecisions.mat')
file='E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell010_C1.mat';
movie='E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell010_C1.tif';
Data=Decisions2Data(Decisions,movie,file,1);
P=randperm(length(Data));
DataTrain=[DataTrain,Data(P(1:trn))];
DataVal=[DataVal,Data(P(1+trn:trn+val))];
DataTest=[DataTest,Data(P(1+trn+val:trn+val+tst))];