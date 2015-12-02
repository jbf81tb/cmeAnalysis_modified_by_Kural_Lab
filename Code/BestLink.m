function answ=BestLink(Px,Py,Pint,Dx,Dy,Dint,dThresh)

candidates=length(Dx);
if candidates==0
    answ=0;
    return
end
for m=1:candidates
    dist(m)=sqrt((Px-Dx(m))^2+(Py-Dy(m))^2);
end
if max(dist)>dThresh
    answ=0;
    return
end
if candidates==1
    answ=1;
    return
end
metric=zeros(1,candidates);
for m=1:candidates
    if Px==0
        metric(m)=1/Dint(m);
    else
    if Pint>0
        metric(m)=sqrt((Px-Dx(m))^2+(Py-Dy(m))^2)*exp(abs(log(Pint/Dint(m))));
    end
    if Pint==0
        metric(m)=sqrt((Px-Dx(m))^2+(Py-Dy(m))^2);
    end
    end
end
answr=find(metric==min(metric));
answ=answr(1);
