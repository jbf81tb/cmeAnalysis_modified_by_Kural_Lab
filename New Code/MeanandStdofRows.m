means=zeros(length(Es(:,1)),1);
std=zeros(length(Es(:,1)),1);
for i=1:length(Es(:,1))
    if length(nonzeros(Es(i,:)))>1
    means(i)=mean(nonzeros(Es(i,:)));
    std(i)=sqrt(var(nonzeros(Es(i,:))));
    else
        if length(nonzeros(Es(i,:)))==0
        means(i)=0;
        std(i)=0;
        else
            means(i)=nonzeros(Es(i,:));
            std(i)=0;
        end
    end
end