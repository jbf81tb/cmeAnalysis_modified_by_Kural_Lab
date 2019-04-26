function Temp_PlotSplit(Split,Itrace)

if Split~=0
    Strace{1}=Itrace(1:Split);
    Strace{2}=Itrace(Split+1:end);
    ST{1}=1:Split;
    ST{2}=Split+1:length(Itrace);


        plot(Itrace+20,'b')
        hold on
        plot(ST{1},Strace{1},'g')
        hold on
        plot(ST{2},Strace{2},'r')


else

        plot(Itrace+20,'b')


end