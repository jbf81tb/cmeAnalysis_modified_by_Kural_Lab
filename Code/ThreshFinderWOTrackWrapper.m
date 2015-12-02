function Thresh=ThreshFinderWOTrackWrapper(FoundSpots,file,frame) %file is the movie
spot_check=find(FoundSpots(:,1)==frame,1);
while isempty(spot_check)
    prompt = sprintf('Try another frame. (attempted frame %i) ',frame);
    frame = input(prompt);
    spot_check=find(FoundSpots(:,1)==frame,1);
end
done=false;
attempt = 'first';
%frame=ceil(frames/2);
Thresh=0; %Just need to initialize the variable for the next line--value unimportant
while done==false
    lastThresh=Thresh;
    switch attempt
        case 'first'
            Thresh=100*input('Thresh = (Try 10) ');
        case 'not_first'
            Thresh=100*input('Positve number to try that number.\n0 to accept previous input.\nNegative number to accept the absolute value of that number.\nThresh = ');
        case 'too_high'
            Thresh=100*input('Try Lower. ');
    end
    attempt = 'not_first';
    close
    if Thresh==0
        Thresh = lastThresh;
        return
    elseif Thresh<0
        Thresh = -Thresh;
        return
    end
    figure('units','normalized','outerposition',[0 0 1 1]);
    A=imread(file,'Index',frame);
    [b,c]=size(A);
    for i2=-4:4
        subplot(3,3,i2+5)
        axis equal
        Threshs=Thresh+50*i2;
        B(:,:,1)=A;
        B(:,:,2)=A;
        B(:,:,3)=A;
        ind=find(FoundSpots(:,1)==frame);
        bright=max(max(A))/1;
        [L]=length(ind);
        Bim=zeros(b,c);
        for j=1:L
            if FoundSpots(ind(j),4)>=Threshs
                x=floor(FoundSpots(ind(j),2));
                y=floor(FoundSpots(ind(j),3));
                Bim(y,x)=1;
                singles=bwboundaries(Bim(:,:),'noholes');
                for k1=0:1
                    for k2=0:1
                        B(y+k1,x+k2,1)=bright;
                        B(y+k1,x+k2,2)=0;
                        B(y+k1,x+k2,3)=0;
                    end
                end
            end
        end
        if ~exist('singles','var') || isempty(singles)
            attempt = 'too_high';
            continue
        end
        for i=1:length(singles)
            y(i)=singles{i,1}(1,1);
            x(i)=singles{i,1}(1,2);
            
        end
        
        
        colormap(gray);
        maximum=65535;
        C=B*(maximum/bright);
        image(C);
    end
end