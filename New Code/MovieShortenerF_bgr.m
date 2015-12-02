function MovieShortenerF_bgr(movie,newfile,start,stop,bg)

for i=start:stop
    A=imread(movie,'Index',i);
    A_bgr = bgr(A,bg);
    imwrite(A_bgr,newfile,'Writemode','append');
end