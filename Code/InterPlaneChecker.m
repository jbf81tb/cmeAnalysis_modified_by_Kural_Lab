clear all;
fxyc1path='FlyP1fxycMHZ.mat';
fxyc2path='FlyP2fxycMHZ_NEW.mat';
fxyc3path='FlyP3fxycMHZ.mat';
movie1='FlyStack2TAvPlane1.tif';
movie2='FlyStack2TAv.tif';
movie3='FlyStack2TAvPlane3.tif';
ExCorr12path='FlyExCorrespondences12_175_New.mat';
ExCorr32path='FlyExCorrespondences32_175_New.mat';
load(fxyc1path);
fxyc1=fxyc;
load(fxyc2path);
fxyc2=fxyc;
load(fxyc3path);
fxyc3=fxyc;
load(ExCorr12path)
ExCorr12=Excorrespondences;
load(ExCorr32path)
ExCorr32=Excorrespondences;

[ExCorr12,fxyc1,fxyc2,countD1,countS1]=CheckForSinglePlaneErrors(ExCorr12,fxyc1,fxyc2,movie1,movie2);
[ExCorr32,fxyc3,fxyc2,countD2,countS2]=CheckForSinglePlaneErrors(ExCorr32,fxyc3,fxyc2,movie3,movie2);

errors=[countD1 countD2 countS1 countS2];
save FlyData_PostCheck.mat ExCorr12 ExCorr32 fxyc1 fxyc2 fxyc3 movie1 movie2 movie3 errors

