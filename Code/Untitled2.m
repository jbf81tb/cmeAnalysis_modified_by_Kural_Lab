num=0;
SolTwo=csvread('SolTwo.csv');
for i=1:3624
    for j=1:3624
        if SolTwo(i,j)==1
            num=num+1;
        end
    end 
end
num