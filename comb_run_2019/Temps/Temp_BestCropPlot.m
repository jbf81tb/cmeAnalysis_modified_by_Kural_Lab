function Temp_BestCropPlot(Itrace,framegap)

[Beg,Fin,Forig,Fnew]=FindBestCrop(Itrace,framegap);
if Beg~=0 && (Beg~=1 || Fin ~=length(Itrace))
    Strace{1}=Itrace(Beg:Fin);
    ST{1}=Beg:Fin;
    plot(Itrace+20,'b')
    hold on
    plot(ST{1},Strace{1},'g')
    L{1}=num2str(Forig);
    L{2}=num2str(Fnew);
else
    plot(Itrace+20,'b')
    L{1}=num2str(Forig);
end
legend(L)