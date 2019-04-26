movies=FindFiles('Z:\Scott\donuts_from_nathan','*.tif');
FGs=[7 6 2 2];
load('Z:\Scott\donuts_from_nathan\tracking_data.mat')
for i=1:length(movies)
    used=find([tracking_data.movie]==i);
    fxycS=tracking_data(used);
    [C,B,E,F1]=ClassifyTraces_WHit_Struct_TIRF(fxycS,movies{i},FGs(i));
    for i2=1:length(used)
        I=used(i2);
        tracking_data(I).class=C(i2);
        tracking_data(I).beginning_goodness=B(i2);
        tracking_data(I).end_goodness=E(i2);
        tracking_data(I).goodness=F1(i2);
    end
end