clear all;
fxyc=CalculateIntensities('FlyPlane1Threshfxyc175.mat','FlyStack2TAvPlane1.tif',308);
save FlyP1ManualInt175_2.mat fxyc
fxyc=CalculateIntensities('FlyPlane3Threshfxyc175.mat','FlyStack2TAvPlane3.tif',308);
save FlyP3ManualInt175_2.mat fxyc
