function MovieFormatter(file,name,frames)
mkdir(name);
copyfile(file,name);
cd(name);
maxdigits=1;
while maxdigits<min(999,frames)
    maxdigits=maxdigits*10;
end

for i=1:min(999,frames)
    j=1;
    while j<=i
        j=j*10;
    end
    pad=log10(maxdigits/j);
    number='';
    for k=1:pad
        number=strcat('0',number);
    end
    number=strcat(number,num2str(i));
    filename=strcat(name,'_',number,'.tiff');
    D=imread(file,'index',i);
    imwrite(D,filename,'Writemode','append');
end
delete(file);
