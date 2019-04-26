clear
file='E:\CME Superfolder\CME Data\190111_Analysis\100ms\squarecrop\split_movies\cell001_C1\Section1\Cell1_1\ch1\Tracking\ProcessedTracks.mat';
movie='E:\CME Superfolder\CME Data\190111_Analysis\100ms\squarecrop\orig_movies\cell001_C1.tif';
framegap=1;
Data=Tracks2Data(movie,file,framegap);
NBins=20;
medInorm=0;
[X,yBeg,yEnd]=ConstructFeatures_SAV_DifMovs(Data,NBins,medInorm);
[C,B,E,F1]=CategorizeExample_new(X);
C=CategorizeWHit(C,[Data.Hits]);
for i=1:length(Data)
    Data(i).Cat=C(i);
end
file='E:\CME Superfolder\CME Data\190111_Analysis\100ms\squarecrop\orig_movies\cell001_C1_Data.mat';
save(file,'Data')
BoxByC_Data(file,movie,[1 2 3 5 6 7])
BoxAll_Data(file,movie)

%%
file='E:\CME Superfolder\CME Data\190111_Analysis\100ms\squarecrop\split_movies\cell001_C1\Section1\Cell1_1\ch1\Tracking\ProcessedTracks.mat';
movie='E:\CME Superfolder\CME Data\190111_Analysis\100ms\squarecrop\orig_movies\cell001_C1.tif';
BoxByC_tracks(file,movie)

%%
clear
file='E:\CME Superfolder\CME Data\190111_Analysis\100ms\squarecrop\orig_movies\cell001_C1.mat';
movie='E:\CME Superfolder\CME Data\190111_Analysis\100ms\squarecrop\orig_movies\cell001_C1.tif';
framegap=1;
Data=FXYC2Data(movie,file,framegap);
NBins=20;
medInorm=0;
[X,yBeg,yEnd]=ConstructFeatures_SAV_DifMovs(Data,NBins,medInorm);
[C,B,E,F1]=CategorizeExample_new(X);
C=CategorizeWHit(C,[Data.Hits]);
for i=1:length(Data)
    Data(i).Cat=C(i);
end
file='E:\CME Superfolder\CME Data\190111_Analysis\100ms\squarecrop\orig_movies\cell001_C1_Data_fromfxyc.mat';
save(file,'Data')
newfile=strcat(movie(1:end-4),'fxycMLCBoxes17.tif');
BoxByC_Data(file,movie,newfile,[1 2 3 5 6 7])
newfile=strcat(movie(1:end-4),'fxycAllBoxes.tif');
BoxAll_Data(file,movie,newfile)