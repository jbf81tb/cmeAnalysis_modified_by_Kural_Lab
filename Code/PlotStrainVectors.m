function PlotStrainVectors(frame,file,fxyc)
%Makes figure with velocity vectors of the spots in inds colored according
%to strain

i=frame;
A=imread(file,'Index',i);
    %if i==5
        maxint=max(max(A)); %need this to display image in a visible way--keep it the same for all frames for consistency
    %end
    colormap(gray)
    imagesc(A,[0 maxint]);
    hold on
    if i~=1
        [x,y,u,v,colors]=GetStrainVectors(fxyc,i);
        colors=autumn;
    else
        x=1;
        y=1;
        u=1;
        v=1;
    end
    for j=1:64
        
        xs=[];
        ys=[];
        us=[];
        vs=[];
        xs=nonzeros(x(j,:));
        number=length(xs);
        for k=1:number
            ys(k)=y(j,k);
            us(k)=u(j,k);
            vs(k)=v(j,k);
        end
        if number>0
        Arrows(j)=quiver(xs,ys,us,vs,0,'color',colors(j,:));
        adjust_quiver_arrowhead_size(Arrows(j),3);
        end
        
    end
