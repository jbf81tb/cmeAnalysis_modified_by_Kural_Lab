function Links=PCLink(Px,Py,Pint,Cx,Cy,Cint,dThresh,aThresh,Thresh)
%Takes parent and child data and returns which parents link best to which
%children s.t. if Links(i,j)==1, parent i should be linked to child j

Parents=length(Px);
Children=length(Cx);
Links=zeros(Parents,Children);
Costs=Links;
Max=20; %Approximate maximum acceptable cost
if Parents==0 || Children==0
    return
end
if Parents==1 && Children==1
    if sqrt((Px(1)-Cx(1))^2+(Py(1)-Cy(1))^2)<=dThresh && exp(abs(log(Pint(1)/Cint(1))))<=aThresh && max(Cint(1),Pint(1))>Thresh
        Links(1,1)=1;
        return
    else
        return
    end
end
for i=1:Parents
    if Pint(i)==0
        Pint(i)=Thresh;
    end
end
for i=1:Parents
    for j=1:Children
        d=sqrt((Px(i)-Cx(j))^2+(Py(i)-Cy(j))^2);
        dA=exp(abs(log(Pint(i)/Cint(j))));
        if d<=dThresh && dA<=aThresh
            Costs(i,j)=d*dA;
        else
            Costs(i,j)=Inf;
        end
        if Pint(i)<=Thresh && Cint(j)<=Thresh
            Costs(i,j)=Inf;
        end
    end
end
FullCosts=[[Costs eye(Parents)*Max];[eye(Children)*Max Costs.']];
[a,b]=size(FullCosts);
for i=1:a
    for j=1:b
        if FullCosts(a,b)==0
            FullCosts(a,b)=Inf;
        end
    end
end
[A,~,~,~,~]=lapjv(FullCosts); %Finds minimal cost matrix choices
for i=1:Parents
    if A(i)<=Children
        if sqrt((Px(i)-Cx(A(i)))^2+(Py(i)-Cy(A(i)))^2)<=dThresh && exp(abs(log(Pint(i)/Cint(A(i)))))<=aThresh
        Links(i,A(i))=1;
        end
    end
end