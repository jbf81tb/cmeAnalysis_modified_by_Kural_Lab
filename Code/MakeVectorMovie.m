clear all %this needs to be automated much better--right now it works specifically for this one movie
close all
file='FlyStack2TAv.tif'; %file to take intensity plot from
newfile='FlyVectors2';
type='.tif';
load('Flyfxyc.mat');
frames=308;
colorgroups=10;
colormap(gray) %important for displaying image
%h=waitbar(0,'Filling Loading Bar');
    dig = floor(log10(frames))+1;
switch dig
    case 1
        prec=num2str(1);
    case 2
        prec=num2str(2);
    case 3
        prec=num2str(3);
    case 4
        prec=num2str(4);
end
%prec=num2str(3);
setting=strcat('%0',prec,'d');
for i=5:frames
    %waitbar(i/frames);
    A=imread(file,'Index',i);
    if i==5
        maxint=max(max(A)); %need this to display image in a visible way--keep it the same for all frames for consistency
    end
    colormap(gray)
    imagesc(A,[0 maxint]);
    hold on
    if i~=1
        [x,y,u,v,colors]=GetVelocityVectors(fxyc,i,colorgroups);
    else
        x=1;
        y=1;
        u=1;
        v=1;
    end
    for j=1:colorgroups
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
        Arrows(j)=quiver(xs,ys,us,vs,0,'color',colors(j,:));
        adjust_quiver_arrowhead_size(Arrows(j),3);
    end

ifile=strcat(newfile,'_',sprintf(setting,i),'.tif');
export_fig(ifile);
    close
end
%close(h)