function fxyc=CalculateZPostionsF(path,ExCorrPath)
%Load files, initialize other variables
load(path)
load(ExCorrPath)
frames=max(max(fxyc1(:,1,:)));
OfInterest=find(fxyc2(1,1,:));
I1=zeros(length(OfInterest),frames);
I2=zeros(length(OfInterest),frames);
I3=zeros(length(OfInterest),frames);

h=waitbar(0,'Finding Axial Positions');
for i=1:length(OfInterest) %Go through all detected spots that are in all plane
    waitbar(i/length(OfInterest))
    for i2=1:length(ExCorr12(:,OfInterest(i))) %Find trace from that spot in plane 1
        Temp=ExCorr12{i2,OfInterest(i)};
        if ~isempty(Temp) 
            for i3=1:length(Temp) %Go through all frames where the traces are together
                wanted=find(fxyc1(:,1,i2)==Temp(i3));
                int=fxyc1(wanted(1),8,i2); %Find intensity in plane 1
                I1(i,Temp(i3))=max(I1(i,Temp(i3)),int); %Keep track of the highest one
            end
        end
    end
    for i2=1:length(ExCorr32(:,OfInterest(i))) %Find trace from that spot in plane 3
        Temp=ExCorr32{i2,OfInterest(i)};
        if ~isempty(Temp) 
            for i3=1:length(Temp) %Go through all frames where the traces are together
                wanted=find(fxyc3(:,1,i2)==Temp(i3));
                int=fxyc3(wanted(1),8,i2); %Find intensity in plane 3
                I3(i,Temp(i3))=max(I3(i,Temp(i3)),int); %Keep track of the highest one, to determine z position later
            end
        end
    end
    used2=find(fxyc2(:,1,OfInterest(i)));
    for i2=1:length(used2) %Same thing for plane 2--Simpler because Selected is in terms of plane 2 traces
        int=fxyc2(used2(i2),8,OfInterest(i));
        I2(i,fxyc2(used2(i2),1,OfInterest(i)))=max(I2(i,fxyc2(used2(i2),1,OfInterest(i))),int);
        offset=min(min(I1(i,fxyc2(used2(i2),1,OfInterest(i))),I2(i,fxyc2(used2(i2),1,OfInterest(i)))),I3(i,fxyc2(used2(i2),1,OfInterest(i))));
        z=(1*I1(i,fxyc2(used2(i2),1,OfInterest(i)))+2*I2(i,fxyc2(used2(i2),1,OfInterest(i)))+3*I3(i,fxyc2(used2(i2),1,OfInterest(i))))/(I1(i,fxyc2(used2(i2),1,OfInterest(i)))+I2(i,fxyc2(used2(i2),1,OfInterest(i)))+I3(i,fxyc2(used2(i2),1,OfInterest(i))));
        fxyc2(used2(i2),10,OfInterest(i))=z;
    end
end
close(h)
fxyc=fxyc2;
