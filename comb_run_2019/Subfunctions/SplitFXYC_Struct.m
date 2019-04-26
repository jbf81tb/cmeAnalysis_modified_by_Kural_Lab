function fxycS=SplitFXYC_Struct(fxycS)

N=length(fxycS);
for i=1:N
    if length(fxycS(i).Splits)>1
        fxyc=fxycS(i);
        ss=[1 fxyc.Splits(2:end) length(fxyc.frame)];
        nsplits=length([fxyc.Splits]);
        for i2=1:nsplits
            frames=fxyc.frame(ss(i2):ss(i2+1));
            ints=fxyc.int(ss(i2):ss(i2+1));
            xpos=fxyc.xpos(ss(i2):ss(i2+1));
            ypos=fxyc.ypos(ss(i2):ss(i2+1));
            cl=fxyc.split_class(i2);
            g=fxyc.split_goodness(i2);
            lt=length(frames)-1;
            if i2==1
                T=i;
            else
                T=length(fxycS)+1;
            end
            fxycS(T).frame=frames;
            fxycS(T).int=ints;
            fxycS(T).xpos=xpos;
            fxycS(T).ypos=ypos;
            fxycS(T).class=cl;
            fxycS(T).classML=cl;
            fxycS(T).goodness=g;
            fxycS(T).classCME=[];
            fxycS(T).Splits=0;
            fxycS(T).split_goodness=g;
            fxycS(T).split_class=cl;
            fxycS(T).lt=lt;
        end
    end
end
fxycS=RedoEndDetection_Struct(fxycS);
