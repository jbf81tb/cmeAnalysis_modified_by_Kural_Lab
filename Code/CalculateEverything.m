%Use this the do all the post calculations you need on your 3 frame movie
clear all
path1='FlyECropP1_90.mat';
path2='FlyECropP2_90.mat';
path3='FlyECropP3_90.mat';
movie1='FlyECropP1.tif';
movie2='FlyECropP2.tif';
movie3='FlyECropP3.tif';

frames=length(imfinfo(movie1));

fxyc=CalculateIntensities(path1,movie1,frames);
save FlyECropP1fxycMHZ_Simple.mat fxyc

fxyc=CalculateIntensities(path2,movie2,frames);
save FlyECropP2fxycMHZ_Simple.mat fxyc

fxyc=CalculateIntensities(path3,movie3,frames);
save FlyECropP3fxycMHZ_Simple.mat fxyc

[ExCorr12,ExCorr32]=LookForTraceCorrespondencesF(path1,path2,path3);
save FlyECropExcorr_Simple.mat ExCorr12 ExCorr32

fxyc=CalculateHWHM('FlyECropP1fxycMHZ.mat',movie1,frames);
save FlyECropP1fxycMHZ_Simple.mat fxyc
fxyc=CalculateHWHM('FlyECropP2fxycMHZ.mat',movie2,frames);
save FlyECropP2fxycMHZ_Simple.mat fxyc
fxyc=CalculateHWHM('FlyECropP3fxycMHZ.mat',movie3,frames);
save FlyECropP3fxycMHZ_Simple.mat fxyc

fxyc=CalculateZPostionsF('FlyECropP1fxycMHZ.mat','FlyECropP2fxycMHZ.mat','FlyECropP3fxycMHZ.mat','FlyECropExcorr.mat');
fxyc=ReClassifyTraces(fxyc);
save FlyECropP2fxycMHZ_Simple.mat fxyc