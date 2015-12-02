function [BegPL,FinPL]=EndDecision(Ints,fade,Thresh) %Give it a vector of the intensity data, it determines whether there are true beginning or end events, and tells you the position and length of the events
%Only give it vectors at least 6 points long

BegPL=[];
FinPL=[];
a=length(Ints);
if a<6
    return
end
used=0;

for i=1:a-6 %search for stretches where the intensity increases almost monotonically for at least 6 time points
    beg=0;
    j=1;
    while i+j-1<a-1
        if Ints(i+j-1)<Ints(i+j+1)
            beg=beg+1;
        else
            break
        end
        j=j+1;
    end
    if beg>=4 && Ints(i)<=Ints(i+beg+1)*fade && i>used && Ints(i+beg+1)>=Thresh*1.5
        BegPL=[BegPL;[i beg+2]];
        used=i+beg+1;
    end
end
used=a+1;
for i=1:a-6 %search for stretches where the intensity decreases almost monotonically for at least 6 time points
    fin=0;
    j=1;
    while i+j-1<a-1
        if Ints(a-(i+j-2))<Ints(a-(i+j))
            fin=fin+1;
        else
            break
        end
        j=j+1;
    end
    if fin>=4 && Ints(a-i+1-(fin+1))*fade>=Ints(a-i+1) && a-i+1<used && Ints(a-i+1-(fin+1))>=Thresh*1.5
        FinPL=[FinPL;[a-i+1-(fin+1) fin+2]];
        used=a-i+1-(fin+1);
    end
end



