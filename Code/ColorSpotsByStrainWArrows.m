function ColorSpotsByStrainWArrows(fxyc,file,newfile) %adds colored spots to tif stack (named file--rewrites it in a file named newfile) at desired locations--fxyc is a nX4 matrix with the n spots--column 1 frame,column 2 x position, column 3 y position, column 4 color (1 for green, 2 for red)
%strain should be in the 9th slot of fxyc
%Arrows correspond to the Strain, vectors correspond to the velocity
frames=length(imfinfo(file));
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
 PlotStrainVectors(i,file,fxyc)
ifile=strcat(newfile,'_',sprintf(setting,i),'.tif');
export_fig(ifile);
    close
end