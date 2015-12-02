function fxyc=ReClassifyTraces(fxyc)

endsize=2;
fade=.5;
[~,~,TraceNum]=size(fxyc);
lastframe=max(max(fxyc(:,1,:)));
for i=1:TraceNum
    clear inds
    
    inds=find(fxyc(:,1,i));
    frames=fxyc(inds,1,i);
    if length(inds)>2       
        clear firstint lastint ints maxis maxints ints firstint lastint
        fi=inds;
        maxi=find(fxyc(:,8,i)==max(fxyc(:,8,i)));
        maxii=find(fi==maxi(1));
        if length(fi)>=3
        if maxii(1)~=1 && maxii(1)~=length(fi) && length(inds)>8
            maxis=[fi(maxii-1) fi(maxii) fi(maxii+1)];
        else
            if maxii(1)==1
                maxis=[fi(1) fi(2) fi(3)];
            end
            if maxii(1)==length(fi)
                maxis=[fi(length(fi)-2) fi(length(fi)-1) fi(length(fi))];
            end
        end
        end
        if length(inds)<=8 || length(fi)<3
            maxis=[fi(maxii) fi(maxii) fi(maxii)];
        end
        
        for j=1:length(maxis)
            maxints(j)=fxyc(maxis(j),8,i);
        end
        for j=1:length(fi)
            ints(j)=fxyc(fi(j),8,i);
        end
        firsts=find(ints,endsize,'first');
        lasts=find(ints,endsize,'last');
        for j=1:length(firsts)
            firstint(j)=ints(firsts(j));
        end
        for j=1:length(lasts)
            lastint(j)=ints(lasts(j));
        end
        if length(firsts)>0
            beginning=mean(firstint);
            middle=mean(maxints);
            finish=mean(lastint);
            ends=0;
            if beginning<middle*fade && middle>=0 && frames(1)~=1 %middle clause not important with new threshlod
                ends=1;
            end
            if  middle>=0 && finish<middle*fade && frames(length(frames))~=lastframe %clause to make sure the end isn't cut off by the end of the movie
                ends=ends+2;
            end
            if frames(length(frames))==lastframe
                ends=ends+8;
            end
            if frames(1)==1
                ends=ends+4;
            end
            for j=1:length(inds)
                if ends<=3 && ends>0
                    fxyc(inds(j),4,i)=ends;
                end
                if ends==0
                    fxyc(inds(j),4,i)=4;
                end
                if ends==9
                    fxyc(inds(j),4,i)=5;
                end
                if ends==6
                    fxyc(inds(j),4,i)=6;
                end
                if ends==4 || ends==5 || ends==7 || ends==8 || ends>9
                    fxyc(inds(j),4,i)=7;
                end
            end
        else
            for j=1:length(inds)
                fxyc(inds(j),4,i)=4;
            end
        end
    else
        for j=1:length(inds)
            fxyc(inds(j),4,i)=4;
        end
    end
end
