co=[];
for i=1:10586
for j=1:16343
    if correspondences(i,j)~=0
co=[co correspondences(i,j)];
    end
end
end