summ=0;
for i=1:3626
    summ=summ+nansum(tracks(i).A)/length(tracks(i).A)/3626;
    vect(i)=max(tracks(i).A);
end
AV=summ