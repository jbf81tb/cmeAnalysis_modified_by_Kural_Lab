function fxyc=CalculateLinRegParameters(endsize,fxyc) %Calculates slope and R^2 for the endsize points after (and including) the current point and saves them in slot 10 and 11 repectively
%Uses 8 if the trace is less than 20 frames long

[~,~,A]=size(fxyc);
% h=waitbar(0,'Running Intensity Linear Regression');
for i=1:A
%     waitbar(i/A)
    used=find(fxyc(:,1,i));
    if length(used)<20
        E=8;
    else
        E=endsize;
    end
    for i2=1:length(used)-E+1
        ints=zeros(1,E);
        x=zeros(1,E);
        for i3=1:E
            ints(i3)=fxyc(i2+i3-1,5,i);
            x(i3)=fxyc(i2+i3-1,1,i);
        end
        [slope, rsq]=LinearSlopeandR2(x,ints);
        fxyc(i2,10,i)=slope;
        fxyc(i2,11,i)=rsq;
    end
    for i2=max(1,length(used)-E+2):length(used)
        fxyc(i2,10,i)=0;
        fxyc(i2,11,i)=0;
    end
end
% close(h)