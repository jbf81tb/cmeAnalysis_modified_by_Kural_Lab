function [NIVect,NCVect]=FixUnits(IVect,CVect,AreaVect,AveragingTime) %Convert Units of initiations/conclusions per time to initiations per micron^2 per second

for i=1:length(IVect)
    NIVect(i)=IVect(i)/AreaVect(i)/.16^2/AveragingTime;
    NCVect(i)=CVect(i)/AreaVect(i)/.16^2/AveragingTime;
end