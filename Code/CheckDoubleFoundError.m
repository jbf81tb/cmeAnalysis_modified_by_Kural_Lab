function ANS=CheckDoubleFoundError(x1,y1,x2,y2,M1,M2) %Looks for the possiblility of tracking errors when two corresponding traces in adjacent planes diverge
%ANS is a 1x2 vector where the first entry tells you where the trajectory
%in plane 1 should go (1 for (x1,y1) or 2 for(x2,y2))

I11=CalculateInt(M1,x1,y1);
I12=CalculateInt(M1,x2,y2);
I21=CalculateInt(M2,x1,y1);
I22=CalculateInt(M2,x2,y2);
if I12>I11
    ANS(1)=2;
else
    ANS(1)=1;
end
if I21>I22
    ANS(2)=1;
else
    ANS(2)=2;
end
