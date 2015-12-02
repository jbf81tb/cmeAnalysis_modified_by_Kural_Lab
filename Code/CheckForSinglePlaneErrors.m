function [Excorr12,fxyc1,fxyc2,countD,countS]=CheckForSinglePlaneErrors(Excorr12,fxyc1,fxyc2,movie1,movie2)

[A,B]=size(Excorr12);
Thresh=75;
countS=0;
countD=0;
h=waitbar(0,'Checking Traces Against Traces in Adjacent Planes');
maxmove=3;
for i1=1:A
    waitbar(i1/A);
    for i2=1:B
        if ~isempty(Excorr12{i1,i2})
            span1=nonzeros(fxyc1(:,1,i1));
            span2=nonzeros(fxyc2(:,1,i2));
            coincident=Excorr12{i1,i2};
            PossibleErrors=setdiff(union(span1,span2),coincident);
            for i3=1:length(PossibleErrors)
                frame=PossibleErrors(i3);
                span1=nonzeros(fxyc1(:,1,i1));
                span2=nonzeros(fxyc2(:,1,i2));
                if min(span1)<frame
                    temp1=find(span1<frame);
                    temp2=span1(temp1);
                    prev1=max(temp2);
                else
                    temp1=find(span1>frame);
                    temp2=span1(temp1);
                    prev1=min(temp2);
                end
                if min(span2)<frame
                    temp1=find(span2<frame);
                    temp2=span2(temp1);
                    prev2=max(temp2);
                else
                    temp1=find(span2>frame);
                    temp2=span2(temp1);
                    prev2=min(temp2);
                end
                if ~isempty(prev1)
                    prev1iSet=find(fxyc1(:,1,i1)==prev1);
                    prev1i=prev1iSet(1);
                    prev1x=fxyc1(prev1i,2,i1);
                    prev1y=fxyc1(prev1i,3,i1);
                end
                if ~isempty(prev2)
                    prev2iSet=find(fxyc2(:,1,i2)==prev2);
                    prev2i=prev2iSet(1);
                    prev2x=fxyc2(prev2i,2,i2);
                    prev2y=fxyc2(prev2i,3,i2);
                end
                if ismember(frame,span1) && ismember(frame,span2)
                    index1=find(fxyc1(:,1,i1)==frame);
                    index2=find(fxyc2(:,1,i2)==frame);
                    if length(index1)*length(index2)>0
                    x1=fxyc1(index1(1),2,i1);
                    y1=fxyc1(index1(1),3,i1);
                    x2=fxyc2(index2(1),2,i2);
                    y2=fxyc2(index2(1),3,i2);
                    M1=imread(movie1,'Index',frame);
                    M2=imread(movie2,'Index',frame);
                    ANS=CheckDoubleFoundError(x1,y1,x2,y2,M1,M2);
                    if ANS(1)==2 && ~(isempty(prev1) || sqrt((prev1x-x2)^2+(prev1y-y2)^2)<=maxmove*sqrt(frame-prev1))
                        ANS(1)=1;
                    end
                    if ANS(2)==1 && ~(isempty(prev2) || sqrt((prev2x-x1)^2+(prev2y-y1)^2)<=maxmove*sqrt(frame-prev2))
                        ANS(2)=2;
                    end
                    if ANS(1)==2
                        fxyc1(index1(1),2,i1)=x2;
                        fxyc1(index1(1),3,i1)=y2;
                        fxyc1(index1(1),8,i1)=CalculateInt(M1,x2,y2);
                        countD=countD+1;
                    end
                    if ANS(2)==1
                        fxyc2(index2(1),2,i2)=x1;
                        fxyc2(index2(1),3,i2)=y1;
                        fxyc2(index2(1),8,i2)=CalculateInt(M2,x1,y1);
                        countD=countD+1;
                    end
                    if ANS(1)==ANS(2)
                        Excorr12{i1,i2}=[Excorr12{i1,i2} frame];
                    end
                    end
                else
                    if ismember(frame,span1) && ~ismember(frame,span2)
                        index1=find(fxyc1(:,1,i1)==frame);
                        if ~isempty(index1)
                        x1=fxyc1(index1(1),2,i1);
                        y1=fxyc1(index1(1),3,i1);
                        M1=imread(movie1,'Index',frame);
                        M2=imread(movie2,'Index',frame);
                        ANS=CheckSingleUnfoundError(x1,y1,M1,M2,Thresh);
                        if ANS(2)==1 &&  ~(isempty(prev2) || sqrt((prev2x-x1)^2+(prev2y-y1)^2)<=maxmove*sqrt(frame-prev2))
                            ANS(2)=0;
                        end
                        if ANS(1)==0 %Spot was found mistakenly
                            countS=countS+1;
                            fxyc1(index1(1),1,i1)=0;
                            fxyc1(index1(1),2,i1)=0;
                            fxyc1(index1(1),3,i1)=0;
                            fxyc1(index1(1),4,i1)=0;
                            fxyc1(index1(1),5,i1)=0;
                            fxyc1(index1(1),6,i1)=0;
                            fxyc1(index1(1),7,i1)=0;
                            fxyc1(index1(1),8,i1)=0;
                        end
                        if ANS(2)==1
                            countS=countS+1;
                            fxyc2=AddSorted(frame,x1,y1,CalculateInt(x1,y1,M2),fxyc2,i2);
                        end
                        if ANS(1)==ANS(2) && ANS(1)~=0
                            Excorr12{i1,i2}=[Excorr12{i1,i2} frame];
                        end
                        end
                    else
                        if ~ismember(frame,span1) && ismember(frame,span2)
                            index2=find(fxyc2(:,1,i2)==frame);
                            if ~isempty(index2)
                            x2=fxyc2(index2(1),2,i2);
                            y2=fxyc2(index2(1),3,i2);
                            M1=imread(movie1,'Index',frame);
                            M2=imread(movie2,'Index',frame);
                            ANS=CheckSingleUnfoundError(x2,y2,M1,M2,Thresh);
                            if ANS(1)==1 &&  ~(isempty(prev1) || sqrt((prev1x-x2)^2+(prev1y-y2)^2)<=maxmove*sqrt(frame-prev1))
                                ANS(1)=0;
                            end
                            if ANS(2)==0 %Spot was found mistakenly
                                countS=countS+1;
                                fxyc2(index2(1),1,i2)=0;
                                fxyc2(index2(1),2,i2)=0;
                                fxyc2(index2(1),3,i2)=0;
                                fxyc2(index2(1),4,i2)=0;
                                fxyc2(index2(1),5,i2)=0;
                                fxyc2(index2(1),6,i2)=0;
                                fxyc2(index2(1),7,i2)=0;
                                fxyc2(index2(1),8,i2)=0;
                            end
                            if ANS(1)==1
                                countS=countS+1;
                                fxyc1=AddSorted(frame,x2,y2,CalculateInt(x2,y2,M1),fxyc1,i1);
                            end
                            if ANS(1)==ANS(2) && ANS(1)~=0
                                Excorr12{i1,i2}=[Excorr12{i1,i2} frame];
                            end
                            end
                        end
                    end
                end
            end
        end
    end
end
close(h)