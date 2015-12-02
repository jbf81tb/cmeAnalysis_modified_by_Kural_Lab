function [x,y,u,v,colors]=GetStrainVectors(fxyc,frame)
%Calculates the unit velocity vectors of the particles in frame "frame" and puts
%them into the form recognized by 'quiver'.  It also splits them into
%64 groups by their strain values

[a,b,c]=size(fxyc);
xt=[];
yt=[];
ut=[];
vt=[];
L=[];
strain=[];
ArrowLength=10;
for j=5:a
    for k=1:c
        if fxyc(j,1,k)==frame && fxyc(j-4,1,k)>0 && (fxyc(j,2,k)~=fxyc(j-4,2,k) || fxyc(j,3,k)~=fxyc(j-4,3,k))
            xf=fxyc(j,2,k);
            xi=fxyc(j-4,2,k);
            yf=fxyc(j,3,k);
            yi=fxyc(j-4,3,k);
            L=[L sqrt((xf-xi)^2+(yf-yi)^2)];
            strain=[strain fxyc(j,9,k)];
            ut=[ut (xf-xi)*ArrowLength/L(length(L))];
            vt=[vt (yf-yi)*ArrowLength/L(length(L))];
            xt=[xt xf-ut(length(ut))];
            yt=[yt yf-vt(length(vt))];
        end
    end
end
cutoff(1)=prctile(strain,0);
cmap=autumn*1500;
for j=1:64
    cutoff(j+1)=prctile(strain,j/64*100);
    index=1;
    for k=1:length(strain)
        if strain(k)>cutoff(j) && strain(k)<=cutoff(j+1) && strain(k)~=0
            x(j,index)=xt(k);
            y(j,index)=yt(k);
            u(j,index)=ut(k);
            v(j,index)=vt(k);
            index=index+1;
        end
    end
    colors(j,:)=cmap(j,:);
end