figure
for i=1:length(GoodTrace)
    plot(CTrace{i})
    pause
end

%%
%GoodTrace{73}--2-humped test trace
framegap=3;
figure
for i=1:length(GoodTrace)
    Itrace=GoodTrace{i};
    Temp_BestSplitPlot(Itrace,framegap)
    pause
    hold off
end

%%

framegap=3;
figure
for i=1:length(CTrace)
    Itrace=CTrace{i};
    Temp_BestCropPlot(Itrace,framegap)
    pause
    hold off
end

%%

framegap=3;
figure
for i=1:length(BadTrace)
    Itrace=BadTrace{i};
    Temp_BestCropPlot(Itrace,framegap)
    pause
    hold off
end