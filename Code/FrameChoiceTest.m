filename='fullvivo.tif';
for i=1:7
    IM=imread(filename,'Index',i);
    [num(i),~]=FindSpotNumber(IM);
end