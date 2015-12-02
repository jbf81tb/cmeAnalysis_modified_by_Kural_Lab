TotalFrames=4207;
StackNumber=7;
TimeSteps=TotalFrames/StackNumber;
file='FullVivoNorm.tif';
newfile='VivoFocus5.tif';
Thresh=19000;
h=waitbar(0,'Finding Apical Surface in each Frame');
changes=0;
for i=1:TimeSteps
    waitbar(i/TimeSteps)
    num=zeros(1,StackNumber);
    for j=1:StackNumber
        IM=imread(file,'Index',(i-1)*StackNumber+j);
        [num(j),~]=FindSpotNumber(IM,Thresh);
    end
    lastlastwinner=lastwinner
    lastwinner=winner(1);
    winner=find(num==max(num));
    if winner(1)~=lastwinner && winner(1)~=lastlastwinner && num(lastwinner)>=num(winner(1))*.80
        winner(1)=lastwinner;
    end
    if winner(1)~=lastwinner
        changes=changes+1;
    end
    D=imread(file,'Index',(i-1)*StackNumber+winner(1));
    imwrite(D,newfile,'Writemode','append');
    wins(i)=winner(1);
end
close(h)