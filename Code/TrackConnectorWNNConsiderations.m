function [fxyc,num]=TrackConnectorWNNConsiderations(fxyc,Thresh,dThresh2,aThresh,fThresh) %aThresh no longer incorporated after it caused an unfortunate trace split--cmeAnalysis amplitude may be dependent on the past/future of the trace
if isempty(fxyc)
    num = 0;
    return;
end
[A,~,B]=size(fxyc);
startfxyi=zeros(B,4);
finishfxyi=zeros(B,4);
for i=1:B  %record info about starts and ends
    sI=find(fxyc(:,2,i),1,'first');
    fI=find(fxyc(:,2,i),1,'last');
    if ~isempty(sI)
    startfxyi(i,1)=fxyc(sI(1),1,i);
    startfxyi(i,2)=fxyc(sI(1),2,i);
    startfxyi(i,3)=fxyc(sI(1),3,i);
    startfxyi(i,4)=max(fxyc(sI(1),5,i),Thresh-1);
    finishfxyi(i,1)=fxyc(fI(1),1,i);
    finishfxyi(i,2)=fxyc(fI(1),2,i);
    finishfxyi(i,3)=fxyc(fI(1),3,i);
    finishfxyi(i,4)=max(fxyc(fI(1),5,i),Thresh-1);
    end
end
% h=waitbar(0,'Finding Missed Connections');
num=0;
for i=1:B %Find any traces that are start/end close enough in position, time, and intensity
%     waitbar(i/B)
    maxdistNN=fxyc(1,11,i)/3; %Use more lax maxdist restrictions if the spots are in a very sparse area
    actualmaxdist=max(dThresh2,min(7,maxdistNN));
    for j=1:B
       if i~=j && startfxyi(i,1)~=0 && startfxyi(j,1)~=0 && startfxyi(i,1)-finishfxyi(j,1)<=fThresh && startfxyi(i,1)-finishfxyi(j,1)>0 && sqrt((startfxyi(i,2)-finishfxyi(j,2))^2+(startfxyi(i,3)-finishfxyi(j,3))^2)<=actualmaxdist
           clear tempfxyc
           num=num+1;
           frameS=min(min(nonzeros(fxyc(:,1,j))),min(nonzeros(fxyc(:,1,i))));
           frameE=max(max(fxyc(:,1,i)),max(fxyc(:,1,j)));
           tempfxyc=zeros(frameE-frameS+1,7);
           for k=frameS:frameE
               iind=find(fxyc(:,1,i)==k);
               jind=find(fxyc(:,1,j)==k);
               if ~isempty(iind)&& isempty(jind)
                   tempfxyc(k-frameS+1,1)=fxyc(iind(1),1,i);
                   tempfxyc(k-frameS+1,2)=fxyc(iind(1),2,i);
                   tempfxyc(k-frameS+1,3)=fxyc(iind(1),3,i);
                   tempfxyc(k-frameS+1,4)=fxyc(iind(1),4,i);
                   tempfxyc(k-frameS+1,5)=fxyc(iind(1),5,i);
                   tempfxyc(k-frameS+1,6)=fxyc(iind(1),6,i);
                   tempfxyc(k-frameS+1,7)=fxyc(iind(1),7,i);
               end
               if ~isempty(jind)&& isempty(iind)
                   tempfxyc(k-frameS+1,1)=fxyc(jind(1),1,j);
                   tempfxyc(k-frameS+1,2)=fxyc(jind(1),2,j);
                   tempfxyc(k-frameS+1,3)=fxyc(jind(1),3,j);
                   tempfxyc(k-frameS+1,4)=fxyc(jind(1),4,j);
                   tempfxyc(k-frameS+1,5)=fxyc(jind(1),5,j);
                   tempfxyc(k-frameS+1,6)=fxyc(jind(1),6,j);
                   tempfxyc(k-frameS+1,7)=fxyc(jind(1),7,j);
               end
               if ~isempty(iind)&& ~isempty(jind) && fxyc(iind(1),5,i)>=fxyc(jind(1),5,j)
                   tempfxyc(k-frameS+1,1)=fxyc(iind(1),1,i);
                   tempfxyc(k-frameS+1,2)=fxyc(iind(1),2,i);
                   tempfxyc(k-frameS+1,3)=fxyc(iind(1),3,i);
                   tempfxyc(k-frameS+1,4)=fxyc(iind(1),4,i);
                   tempfxyc(k-frameS+1,5)=fxyc(iind(1),5,i);
                   tempfxyc(k-frameS+1,6)=fxyc(iind(1),6,i);
                   tempfxyc(k-frameS+1,7)=fxyc(iind(1),7,i);
               end
               if ~isempty(iind)&& ~isempty(jind) && fxyc(iind(1),5,i)<fxyc(jind(1),5,j)
                   tempfxyc(k-frameS+1,1)=fxyc(jind(1),1,j);
                   tempfxyc(k-frameS+1,2)=fxyc(jind(1),2,j);
                   tempfxyc(k-frameS+1,3)=fxyc(jind(1),3,j);
                   tempfxyc(k-frameS+1,4)=fxyc(jind(1),4,j);
                   tempfxyc(k-frameS+1,5)=fxyc(jind(1),5,j);
                   tempfxyc(k-frameS+1,6)=fxyc(jind(1),6,j);
                   tempfxyc(k-frameS+1,7)=fxyc(jind(1),7,j);
               end
               if isempty(iind)&& isempty(jind) %If no point is found--just use last point found
                   tempfxyc(k-frameS+1,1)=tempfxyc(k-frameS,1);
                   tempfxyc(k-frameS+1,2)=tempfxyc(k-frameS,2);
                   tempfxyc(k-frameS+1,3)=tempfxyc(k-frameS,3);
                   tempfxyc(k-frameS+1,4)=tempfxyc(k-frameS,4);
                   tempfxyc(k-frameS+1,5)=tempfxyc(k-frameS,5);
                   tempfxyc(k-frameS+1,6)=tempfxyc(k-frameS,6);
                   tempfxyc(k-frameS+1,7)=tempfxyc(k-frameS,7);
               end
               if ~isempty(jind)
                   for m=1:length(jind)
                   fxyc(jind(m),1,j)=0;
                   fxyc(jind(m),2,j)=0;
                   fxyc(jind(m),3,j)=0;
                   fxyc(jind(m),4,j)=0;
                   fxyc(jind(m),5,j)=0;
                   fxyc(jind(m),6,j)=0;
                   fxyc(jind(m),7,j)=0;
                   end
               end
           end
           for k=1:length(fxyc(:,2,i)) %put tempfxyc where the i data was
               fxyc(k,1,i)=0;
               fxyc(k,2,i)=0;
               fxyc(k,3,i)=0;
               fxyc(k,4,i)=0;
               fxyc(k,5,i)=0;
               fxyc(k,6,i)=0;
               fxyc(k,7,i)=0;
           end
           for k=1:length(tempfxyc(:,2))
               fxyc(k,1,i)=tempfxyc(k,1);
               fxyc(k,2,i)=tempfxyc(k,2);
               fxyc(k,3,i)=tempfxyc(k,3);
               fxyc(k,4,i)=tempfxyc(k,4);
               fxyc(k,5,i)=tempfxyc(k,5);
               fxyc(k,6,i)=tempfxyc(k,6);
               fxyc(k,7,i)=tempfxyc(k,7);
           end
           startfxyi(j,1)=0; %erase now-empty j data
           startfxyi(j,2)=0;
           startfxyi(j,3)=0;
           startfxyi(j,4)=0;
           finishfxyi(j,1)=0;
           finishfxyi(j,2)=0;
           finishfxyi(j,3)=0;
           finishfxyi(j,4)=0;
           sI=find(fxyc(:,2,i),1,'first'); %fix possibly added to i data
           fI=find(fxyc(:,2,i),1,'last');
           startfxyi(i,1)=fxyc(sI(1),1,i);
           startfxyi(i,2)=fxyc(sI(1),2,i);
           startfxyi(i,3)=fxyc(sI(1),3,i);
           startfxyi(i,4)=max(fxyc(sI(1),5,i),Thresh);
           finishfxyi(i,1)=fxyc(fI(1),1,i);
           finishfxyi(i,2)=fxyc(fI(1),2,i);
           finishfxyi(i,3)=fxyc(fI(1),3,i);
           finishfxyi(i,4)=max(fxyc(fI(1),5,i),Thresh);
       end
    end
end
% close(h)
