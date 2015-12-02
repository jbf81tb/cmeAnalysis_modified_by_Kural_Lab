function fxyac=fxyaMaker(fxyc)
%Takes full fxyc and converts all traces into fxyac format (Currently, all traces are
%considered a 3 unless they hit the end of the movie)
[A,~,B]=size(fxyc);
fxyac=zeros(A,4,B);
for i=1:B
    for i2=1:A
        if fxyc(i2,1,i)>0
            fxyac(i2,1,i)=fxyc(i2,1,i);
            fxyac(i2,2,i)=fxyc(i2,2,i);
            fxyac(i2,3,i)=fxyc(i2,3,i);
            fxyac(i2,4,i)=fxyc(i2,5,i);
            fxyac(i2,5,i)=fxyc(i2,4,i);
            %fxyac(i2,6,i)=fxyc(i2,8,i);
%             if fxyc(i2,4,i)<=4
%                 fxyac(i2,5,i)=3;
%             end
%             if fxyc(i2,4,i)==5
%                 fxyac(i2,5,i)=1;
%             end
%             if fxyc(i2,4,i)==6
%                 fxyac(i2,5,i)=2;
%             end
        end
    end
end

