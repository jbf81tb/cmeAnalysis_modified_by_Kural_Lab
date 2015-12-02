function MovieShortenerF(movie,newfile,start,stop)

for i=start:stop
    A=imread(movie,'Index',i); 
    imwrite(A,newfile,'Writemode','append');
end