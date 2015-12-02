%Use this the do all the post calculations you need on your 3 frame movie
clear all
path1='FlyECropP1_90.mat';
path2='FlyECropP2_90.mat';
path3='FlyECropP3_90.mat';
path='FlyECropfxycMHZ_3.mat';
Excorrpath='FlyECropExcorr_3.mat';
movie1='FlyECropP1.tif';
movie2='FlyECropP2.tif';
movie3='FlyECropP3.tif';

frames=length(imfinfo(movie1));

fxyc1=CalculateIntensities(path1,movie1,frames);
fxyc2=CalculateIntensities(path2,movie2,frames);
fxyc3=CalculateIntensities(path3,movie3,frames);
save(path,'fxyc1','fxyc2','fxyc3');

[ExCorr12,ExCorr32]=LookForTraceCorrespondencesF(path);
load(path);
[ExCorr12,fxyc1,fxyc2,countD1,countS1]=CheckForSinglePlaneErrors(ExCorr12,fxyc1,fxyc2,movie1,movie2);
[ExCorr32,fxyc3,fxyc2,countD2,countS2]=CheckForSinglePlaneErrors(ExCorr32,fxyc3,fxyc2,movie3,movie2);
save(path,'fxyc1','fxyc2','fxyc3');
save(Excorrpath,'ExCorr12','ExCorr32');

fxyc1=CalculateHWHM(path,movie1,frames,1);
fxyc2=CalculateHWHM(path,movie2,frames,2);
fxyc3=CalculateHWHM(path,movie3,frames,3);
save(path,'fxyc1','fxyc2','fxyc3');

[ExCorr12,ExCorr32]=LookForTraceCorrespondencesF(path);
save(Excorrpath,'ExCorr12','ExCorr32');

fxyc2=CalculateZPostionsF(path,Excorrpath);
fxyc2=ReClassifyTraces(fxyc2);
save(path,'fxyc1','fxyc2','fxyc3');