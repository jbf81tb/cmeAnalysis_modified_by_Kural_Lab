cand1=find(Threshfxyc(1,1,:)>=222);
cand2=find(Threshfxyc(1,1,:)<=224);
cand3=find(Threshfxyc(1,2,:)>=313);
cand4=find(Threshfxyc(1,2,:)<=323);
cand5=find(Threshfxyc(1,3,:)>=173);
cand6=find(Threshfxyc(1,3,:)<=273);
cand12=intersect(cand1,cand2);
cand34=intersect(cand3,cand4);
cand56=intersect(cand5,cand6);
cand1234=intersect(cand12,cand34);
cand=intersect(cand1234,cand56);