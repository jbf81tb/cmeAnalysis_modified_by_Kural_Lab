function MovieShortenerF(movie,newfile,start,stop)
%MOVIESHORTENERF Creates a substack of existing movie
%
% Scott Huber, Kural Group, Ohio State University,
% huber.288@buckeyemail.osu.edu
for i=start:stop
    A=imread(movie,'Index',i); 
    imwrite(A,newfile,'Writemode','append');
end