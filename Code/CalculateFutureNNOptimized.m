function fxyc=CalculateFutureNNOptimized(fxyc) %Record NN (where the neighbors are found in the next (next next)) distance in 12th (13th) slot of fxyc for last frame in the trace
%Record NN (where the neighbors are found in the previous (previous previous)) distance in 12th (13th) slot of fxyc for first frame in the trace
if isempty(fxyc), return; end
[~,~,a]=size(fxyc);
frames=max(max(fxyc(:,1,:)));
% h=waitbar(0,'Finding Nearest Neighbor Distances');
x_min=min(min(fxyc(:,2,:)));
x_max=max(max(fxyc(:,2,:)));
y_min=min(min(fxyc(:,3,:)));
y_max=max(max(fxyc(:,3,:)));
for i1=3:frames-2
%     waitbar(i1/frames)
    [indices1,positions1]=FindFramePositions(fxyc,i1);
    [indices2,positions2]=FindFramePositions(fxyc,i1+1);
    [indices3,positions3]=FindFramePositions(fxyc,i1+2);
    [indices_1,positions_1]=FindFramePositions(fxyc,i1-1);
    [indices_2,positions_2]=FindFramePositions(fxyc,i1-2);
    [b1,~]=size(indices1);
    [b2,~]=size(indices2);
    [b3,~]=size(indices3);
    [b_1,~]=size(indices_1);
    [b_2,~]=size(indices_2);
    for i2=1:b1
        if indices1(i2,1)==find(fxyc(:,1,indices1(i2,2)),1,'last')
            x=positions1(i2,1);
            y=positions1(i2,2);
            closest_xedge=min(x_max-x,x-x_min);
            closest_yedge=min(y_max-y,y-y_max);
            closest_edge=min(closest_xedge,closest_yedge);
            closest1=closest_edge;
            closest2=closest_edge;
            for i3=1:b2
                
                x2=positions2(i3,1);
                y2=positions2(i3,2);
                dist=sqrt((x-x2)^2+(y-y2)^2);
                if dist<closest1
                    closest1=dist;
                end
                
            end
            for i3=1:b3
                
                x2=positions3(i3,1);
                y2=positions3(i3,2);
                dist=sqrt((x-x2)^2+(y-y2)^2);
                if dist<closest2
                    closest2=dist;
                end
                
            end
            
            fxyc(indices1(i2,1),12,indices1(i2,2))=closest1; %Record all single frame NN distances (to be averaged later)
            fxyc(indices1(i2,1),13,indices1(i2,2))=closest2;
        end
        if indices1(i2,1)==find(fxyc(:,1,indices1(i2,2)),1,'first')
            x=positions1(i2,1);
            y=positions1(i2,2);
            closest1=100;
            closest2=100;
            for i3=1:b_1
                
                x2=positions_1(i3,1);
                y2=positions_1(i3,2);
                dist=sqrt((x-x2)^2+(y-y2)^2);
                if dist<closest1
                    closest1=dist;
                end
                
            end
            for i3=1:b_2
                
                x2=positions_2(i3,1);
                y2=positions_2(i3,2);
                dist=sqrt((x-x2)^2+(y-y2)^2);
                if dist<closest2
                    closest2=dist;
                end
                
            end
            
            fxyc(indices1(i2,1),12,indices1(i2,2))=closest1; %Record all single frame NN distances (to be averaged later)
            fxyc(indices1(i2,1),13,indices1(i2,2))=closest2;
        end
    end
end
% close(h)