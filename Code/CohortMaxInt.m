function [c10i,c15i,c20i,c40i,c60i,c120i,c10,c15,c20,c40,c60,c120]=CohortMaxInt(life,s6MaxInt,MaxInt)
c10i=[];
c10=[];
c120=[];
c60=[];
c40=[];
c20=[];
c15=[];
c120i=[];
c60i=[];
c40i=[];
c20i=[];
c15i=[];
for i=1:length(life)
    if life(i)<=10
        c10i=[c10i s6MaxInt(i)];
        c10=[c10 MaxInt(i)];
    else
        if life(i)<=15
            c15i=[c15i s6MaxInt(i)];
            c15=[c15 MaxInt(i)];
        else
        if life(i)<=20
            c20i=[c20i s6MaxInt(i)];
            c20=[c20 MaxInt(i)];
        else
        if life(i)<=40
            c40i=[c40i s6MaxInt(i)];
            c40=[c40 MaxInt(i)];
        else
        if life(i)<=60
            c60i=[c60i s6MaxInt(i)];
            c60=[c60 MaxInt(i)];
        else
        if life(i)<=120
            c120i=[c120i s6MaxInt(i)];
            c120=[c120 MaxInt(i)];
        end
        end
        end
        end
        end
    end
end