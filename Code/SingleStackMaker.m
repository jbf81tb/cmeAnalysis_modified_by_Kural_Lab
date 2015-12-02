function SingleStackMaker(file,newfile,stacks,frames)
for i=1:frames

        A=imread(file,'Index',i*stacks-2);


    
    imwrite(A,newfile,'Writemode','append');
end