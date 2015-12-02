strains=[];
for i=1:length(Threshfxyc(1,1,:))
    useds=find(Threshfxyc(:,9,i));
    for j=1:length(useds)
        strains=[strains Threshfxyc(useds(j),9,i)];
    end
end