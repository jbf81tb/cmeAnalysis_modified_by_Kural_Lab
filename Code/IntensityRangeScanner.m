for Meani=1:4
    for Maxi=1:7
        MeanMin=750+250*Meani;
        MeanMax=MeanMin+250;
        MaxMin=1000+250*Maxi;
        MaxMax=MaxMin+250;
        [Selected,MeanInts,MaxInts]=GenerateSelectedVector(Threshfxyc,MeanMin,MeanMax,MaxMin,MaxMax);
        name=strcat('ColdblockShort_Dim_Me_',num2str(MeanMin),'_',num2str(MeanMax),'_Ma_',num2str(MaxMin),'_',num2str(MaxMax),'.tif');
        ColorSelected(Threshfxyc,Selected,MaxInts,file,name)
    end
end