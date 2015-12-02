function [x,y,u,v,colors]=GetVelocityVectors(fxyc,frame,colorgroups)
%Calculates the unit velocity vectors of the particles in frame "frame" and puts
%them into the form recognized by 'quiver'.  It also splits them into
%'colorgroups' number of groups by their relative lengths

[a,b,c]=size(fxyc);
xt=[];
yt=[];
ut=[];
vt=[];
L=[];
ArrowLength=10;
for j=5:a
    for k=1:c
        if fxyc(j,1,k)==frame && fxyc(j-4,1,k)>0 && (fxyc(j,2,k)~=fxyc(j-4,2,k) || fxyc(j,3,k)~=fxyc(j-4,3,k))
            xf=fxyc(j,2,k);
            xi=fxyc(j-4,2,k);
            yf=fxyc(j,3,k);
            yi=fxyc(j-4,3,k);
            L=[L sqrt((xf-xi)^2+(yf-yi)^2)];
            ut=[ut (xf-xi)*ArrowLength/L(length(L))];
            vt=[vt (yf-yi)*ArrowLength/L(length(L))];
            xt=[xt xf-ut(length(ut))];
            yt=[yt yf-vt(length(vt))];
        end
    end
end
cutoff(1)=0;
for j=1:colorgroups
    cutoff(j+1)=prctile(L,j/colorgroups*100);
    index=1;
    for k=1:length(L)
        if L(k)>cutoff(j) && L(k)<=cutoff(j+1)
            x(j,index)=xt(k);
            y(j,index)=yt(k);
            u(j,index)=ut(k);
            v(j,index)=vt(k);
            index=index+1;
        end
    end
    colors(j,:)=[1 1-(j-1)/(colorgroups-1) 0];
end