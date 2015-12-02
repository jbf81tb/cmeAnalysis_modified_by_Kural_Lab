function data=AddToData(Sdata,data)

[a,b]=size(data);
if ~isempty(data)
    less=find(data(1,:)<Sdata(1));
    more=find(data(1,:)>Sdata(1));
    if isempty(less) %Put in first column
        
        for i=1:b
            for i2=1:a
                data(i2,b-i+2)=data(i2,b-i+1); %Move everything over to make room for Sdata
            end
        end
        for i=1:a
            data(i,1)=0; %delete already copied first column
        end
        for i=1:length(Sdata)
            data(i,1)=Sdata(i);
        end
        
    else
        if isempty(more) %put in last column
            for i=1:length(Sdata)
                data(i,b+1)=Sdata(i);
            end
        else
            for i=1:length(more) %move bigger guys over
                for i2=1:a
                    data(i2,b-i+2)=data(i2,b-i+1);
                end
            end
            for i=1:a
                data(i,b-length(more)+1)=0; %delete already copied first column
            end
            for i=1:length(Sdata)
                data(i,b-length(more)+1)=Sdata(i);
            end
        end
    end
else
    data=Sdata;
end