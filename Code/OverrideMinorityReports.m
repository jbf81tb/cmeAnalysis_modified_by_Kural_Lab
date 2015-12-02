function [Excorr12,Excorr32,fxyc1,fxyc2,fxyc3]=OverrideMinorityReports(Excorr12,Excorr32,fxyc1,fxyc2,fxyc3)

[A,~,B]=size(fxyc2);
frames=max(max(fxyc2(:,1,:)));
FoundFrames=FindBigSpots(ExCorr12,ExCorr32,frames); %FoundFrames is a B X frames matrix where an entry is 1 if the spot is found in all 3 planes in that frame

