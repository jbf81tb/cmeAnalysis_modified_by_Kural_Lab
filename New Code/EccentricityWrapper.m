
fxyc=Threshfxyc;
movie='3before_and_after.tif';
fxyc=CalculateEccentricities(movie,fxyc);
fxyc=AverageAboveR2(fxyc,10,8,.8);
save JoshCell3_WEcc.mat fxyc