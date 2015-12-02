function [TraceX,TraceY,TraceINT,TraceF]=TrackDecoderMultiPlane(path,MultiPlanePath,frames,Thresh,dThresh,aThresh)

load(path) %automate file detection
load(MultiPlanePath)
[~,TOTtraces]=size(tracks);

tracksx=table({tracks.x}.','VariableNames',{'x'});
tracksy=table({tracks.y}.','VariableNames',{'y'});
tracksf=table({tracks.f}.','VariableNames',{'f'});
tracksA=table({tracks.A}.','VariableNames',{'A'});
TraceX=zeros(TOTtraces*10,frames); %If this starts running more slowly part way through the 'Processing Traces' part, change the 20 to something bigger
TraceY=zeros(TOTtraces*10,frames);
TraceINT=zeros(TOTtraces*10,frames);
TraceF=zeros(TOTtraces*10,frames);
i=1;
h=waitbar(0,'Processing Traces');
for k=1:TOTtraces
    waitbar(k/TOTtraces)
    if max(tracks(k).A)>Thresh
        clear x y f A isCCP NewTraceX NewTraceY NewTraceINT Dx Dy Dint Dxt Dyt Dintt Px Py Pint inci incit
        NewTraceX=zeros(1,frames);
        NewTraceY=zeros(1,frames);
        NewTraceINT=zeros(1,frames);
        
        EmptyNew=1;
        x=tracksx.x{k,1};
        y=tracksy.y{k,1};
        f=tracksf.f{k,1};
        A=tracksA.A{k,1};
        
        for j=1:length(x)
            clear Dx Dy Dint Dxt Dyt Dintt Px Py Pint inci incit
            found1=find(FoundSpotsMP(:,1)==f(j));
            found2=find(FoundSpotsMP(:,2)==x(j));
            found=intersect(found1,found2);
            if f(j)>0 %Check that the data has valid frame, and that it's found in an adjacent plane
                inci=find(f==f(j));
                if (j==1 || f(j)==1) && inci(1)==j
                    for m=1:length(inci)
                        if A(inci(m))>Thresh && length(found)>0
                            NewTraceX(EmptyNew,f(j))=x(inci(m));
                            NewTraceY(EmptyNew,f(j))=y(inci(m));
                            NewTraceINT(EmptyNew,f(j))=A(inci(m));
                            
                        else
                            NewTraceX(EmptyNew,f(j))=x(inci(m));
                            NewTraceY(EmptyNew,f(j))=y(inci(m));
                            NewTraceINT(EmptyNew,f(j))=0;
                           
                        end
                        EmptyNew=EmptyNew+1;
                    end
                else
                    if inci(1)==j
                        back=0;
                        pars=[];
                        while length(pars)==0
                            back=back+1;
                            if back==f(j)
                                break
                            end
                            pars=find(NewTraceX(:,f(j)-back));
                        end
                        if back==f(j)
                            continue
                        end
                        for m=1:length(pars)
                            Px(m)=NewTraceX(pars(m),f(j)-back);
                            Py(m)=NewTraceY(pars(m),f(j)-back);
                            Pint(m)=NewTraceINT(pars(m),f(j)-back);
                        end
                        for m=1:length(inci)
                            Dx(m)=x(inci(m));
                            Dy(m)=y(inci(m));
                            Dint(m)=A(inci(m));
                        end
                        Links=PCLink(Px,Py,Pint,Dx,Dy,Dint,dThresh,aThresh,Thresh);
                        [a,b]=size(Links);
                        Used=zeros(1,b);
                        for m=1:a
                            for n=1:b
                                if Links(m,n)==1
                                    NewTraceX(pars(m),f(j))=Dx(n);
                                    NewTraceY(pars(m),f(j))=Dy(n);
                                    if Dint(n)>Thresh
                                        NewTraceINT(pars(m),f(j))=Dint(n);
                                    else
                                        NewTraceINT(pars(m),f(j))=0;
                                    end
                                    
                                    Used(n)=1;
                                end
                            end
                        end
                        for m=1:b
                            if Used(m)==0
                                if Dint(m)>Thresh
                                    NewTraceX(EmptyNew,f(j))=Dx(m);
                                    NewTraceY(EmptyNew,f(j))=Dy(m);
                                    NewTraceINT(EmptyNew,f(j))=Dint(m);
                                    
                                else
                                    NewTraceX(EmptyNew,f(j))=Dx(m);
                                    NewTraceY(EmptyNew,f(j))=Dy(m);
                                    NewTraceINT(EmptyNew,f(j))=0;
                                    
                                end
                                EmptyNew=EmptyNew+1;
                            end
                        end
                    end
                end
            end
        end
        [a,~]=size(NewTraceX);
        %Take traces and see if some are artificially broken up. If so,
        %glue them together and us the max int if there is an overlap.
        if a>1
            start=zeros(1,a);
            finish=zeros(1,a);
            for j=1:a
                if ~isempty(find(NewTraceINT(j,:)))
                    start(j)=find(NewTraceINT(j,:),1,'first');
                    finish(j)=find(NewTraceINT(j,:),1,'last');
                end
            end
            for j=1:a
                for m=1:a
                    if m~=j
                        if start(j)~=0 && finish(m)~=0 && abs(start(j)-finish(m))<=3 && exp(abs(log(NewTraceINT(j,start(j))/NewTraceINT(m,finish(m)))))<=1.5 && sqrt((NewTraceX(j,start(j))-NewTraceX(m,finish(m)))^2+(NewTraceY(j,start(j))-NewTraceY(m,finish(m)))^2)<3
                            for n=1:frames
                                if NewTraceINT(m,n)>NewTraceINT(j,n)
                                    NewTraceINT(j,n)=NewTraceINT(m,n);
                                    NewTraceX(j,n)=NewTraceX(m,n);
                                    NewTraceY(j,n)=NewTraceY(m,n);
                                end
                                NewTraceX(m,n)=0;
                                NewTraceY(m,n)=0;
                                NewTraceINT(m,n)=0;
                            end
                            start(j)=start(m);
                            start(m)=0;
                            finish(m)=0;
                        end
                    end
                end
            end
        end
        for j=1:a
            if ~isempty(find(NewTraceX(j,:)))
                TraceX(i,:)=NewTraceX(j,:);
                TraceY(i,:)=NewTraceY(j,:);
                TraceINT(i,:)=NewTraceINT(j,:);
                TraceF(i,:)=ones(1,length(NewTraceX(j,:)))*k;
                i=i+1;
            end
        end
    end
end
close(h)