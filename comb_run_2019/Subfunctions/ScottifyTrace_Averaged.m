function STrace=ScottifyTrace_Averaged(trace,NBins)
    
    Oversample=100;
    SCell=cell(1,NBins);
    NBinsV=1:NBins*Oversample;
    xq=(NBinsV-1)/(NBins*Oversample-1)*(length(trace)-1)+1;
    vq=interp1(trace,xq);
    for i=1:NBins
        STrace(i)=mean(vq((i-1)*Oversample+1:i*Oversample));
    end
        
