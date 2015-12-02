[A1,A2,A]=size(ThreshfxycA);
[B1,B2,B]=size(ThreshfxycB);
[C1,C2,C]=size(ThreshfxycC);
startA=86;
startB=600;
startC=1;
index=1;
Threshfxyc=zeros(max(max(A1,B1),C1),max(C2,max(A2,B2)),A+B+C);
h=waitbar(0,'Combining Trace Sections');
for i1=1:A
    waitbar(i1/A/3)
    used=find(ThreshfxycA(:,1,i1));
    for i2=1:length(used)
        ThreshfxycA(used(i2),1,i1)=ThreshfxycA(used(i2),1,i1)+startA-1;
        
    end
    for i2=1:A1
        for i3=1:A2
    Threshfxyc(i2,i3,index)=ThreshfxycA(i2,i3,i1);
    
        end
    end
    index=index+1;
end
for i1=1:B
    waitbar(i1/B/3+1/3)
   
    used=find(ThreshfxycB(:,1,i1));
    for i2=1:length(used)
        ThreshfxycB(used(i2),1,i1)=ThreshfxycB(used(i2),1,i1)+startB-1;
    end
    for i2=1:B1
        for i3=1:B2
    Threshfxyc(i2,i3,index)=ThreshfxycB(i2,i3,i1);
    
        end
    end
    index=index+1;
end 
% for i1=1:C
%     waitbar(i1/C/3+2/3)
%    if (ThreshfxycC(1,4,i1)==3 || ThreshfxycC(1,4,i1)==8) && ThreshfxycC(1,1,i1)>=61
%     used=find(ThreshfxycC(:,1,i1));
%     for i2=1:length(used)
%         ThreshfxycC(used(i2),1,i1)=ThreshfxycC(used(i2),1,i1)+startC-1;
%     end
%     for i2=1:C1
%         for i3=1:C2
%     Threshfxyc(i2,i3,index)=ThreshfxycC(i2,i3,i1);
%     
%         end
%     end
%     index=index+1;
%    end
% end 
close(h)

