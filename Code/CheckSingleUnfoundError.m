function ANS=CheckSingleUnfoundError(x,y,M1,M2,Thresh) %Looks for the possiblility of tracking errors when two corresponding traces in adjacent end at different times
%ANS is a 1x2 vector that is 1 or 0 in entry 1 if a spot was found at the
%point in plane 1 and similarly for plane 2
I1=CalculateInt(M1,x,y);
I2=CalculateInt(M2,x,y);
if I1>=Thresh
    ANS(1)=1;
else
    ANS(1)=0;
end
if I2>=Thresh
    ANS(2)=1;
else
    ANS(2)=0;
end
    
