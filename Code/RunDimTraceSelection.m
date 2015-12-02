BoundryPath='ColdblockBeginning_Boundries.mat';
CropBoundryPath='ColdblockBeginning_CropBoundries.mat';
load(BoundryPath)
Threshfxyc=FindDistanceToEdge(Threshfxyc,Bx,By,6);
load(CropBoundryPath)
Threshfxyc=FindDistanceToEdge(Threshfxyc,Bx,By,7);
[Threshfxyc,Selected1,MeanInts1,MaxInts1]=GenerateSelectedVector(Threshfxyc,1000,1250,1500,2000);
[Threshfxyc,Selected2,MeanInts2,MaxInts2]=GenerateSelectedVector(Threshfxyc,1250,1500,1250,2500);

