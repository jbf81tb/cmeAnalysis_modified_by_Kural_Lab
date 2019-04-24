function C=CategorizeWHit(C,Hit)

Mat=[[1 2 3 4];[7 6 6 7];[5 7 5 7];[7 7 7 7]];
for i=1:length(C)
    C(i)=Mat(Hit(i)+1,C(i));
end