function ConvertToRBG(file,frame1,frame2)



dig = floor(log10(frame2))+1;
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
prec=num2str(3);
setting=strcat('%0',prec,'d');
newfile=strcat(file,'.tif');
for i=frame1:frame2
    ifile=strcat(file,'_',sprintf(setting,i),'.tif');
    A=imread(ifile);
    B(:,:,1)=A(:,:);
    B(:,:,2)=A(:,:);
    B(:,:,3)=A(:,:);
    imwrite(B,newfile,'Writemode','append','Compression','none')
    %delete(ifile);  Add in when confindent it won't make a mistake
end