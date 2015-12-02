function [X2,Y2,INT2]=FindSpots(IM,Thresh)

filter='a';
windowsize=5;
windowsize = 2*floor((windowsize+1)/2) - 1;
bigwindowsize = windowsize + 4;
PixelSize = 160; % nm
mex = -fspecial('log',9,1.5);
frames=1;
s = size(IM);
J = zeros(s(1),s(2),frames,'uint16');
IMG = zeros(s(1),s(2),frames,'double');
scale = ones([1,frames],'double');
mask = [0 1 1 1 0;...
            1 1 1 1 1;...
            1 1 1 1 1;...
            1 1 1 1 1;...
            0 1 1 1 0];
for j=1:frames
    IMG(:,:,j) = IM;
    J(:,:,j) = imfilter(IMG(:,:,j),mex,'symmetric');
    %if filter == 'a'
        [x,y] = create_histogram(J(:,:,j));
        scale(j) = best_fit_approx_n(x,y,5);
    %end
    
end

MEAN=mean(J,3);
for k = 1:frames
    scale(k) = filter;
end
for k = 1:frames
    J(:,:,k) = J(:,:,k)/scale(k);
    J(:,:,k) = im2bw(J(:,:,k),0);
    J(:,:,k) = double(J(:,:,k)).*IMG(:,:,k);
end
BW = zeros(s(1),s(2),frames);

%h = waitbar(0,'Isolating CCPs...');
%bar_color_patch_handle = findobj(h,'Type','Patch');
%set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for k =1:frames
    BW(:,:,k) = imregionalmax(floor(J(:,:,k)), 8); %makes image with 1's on regional maxima and 0's everywhere else
    %waitbar(k / frames)
end
%close(h);
%Predefine matrices for tracking CCPs. BACK and INT have arbitrary
%predefinition (will usually be too small).
B_sample = bwboundaries(BW(:,:,1),'noholes'); %finds boundaries of 1 groups in BW
BACK = zeros(length(B_sample),frames);
INT = zeros(length(B_sample),frames);
Xc = zeros(frames,1);
Yc = zeros(frames,1);

%h = waitbar(0,'Locating CCPs...');
%bar_color_patch_handle = findobj(h,'Type','Patch');
%set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');

for k=1:frames
    B = bwboundaries(BW(:,:,k),'noholes');
    q=0;
    for m=1:length(B)
        c=cell2mat(B(m));
        q=q+1;
        Py=uint16(mean(c(:,1))); %approximate locations of maxima
        Px=uint16(mean(c(:,2)));
        
        if (Px-(bigwindowsize+1)/2)<1 || (Py-(bigwindowsize+1)/2)<1 || (Px+(bigwindowsize+1)/2)>s(2) || (Py+(bigwindowsize+1)/2)>s(1)
            [Window, BigWindow] = make_windows(Px,Py,windowsize,s,IMG(:,:,k));
        else
            Window = zeros(windowsize,windowsize);
            for i=1:windowsize
                for j=1:windowsize
                    Window(i,j)=IMG(Py-(windowsize+1)/2+i,Px-(windowsize+1)/2+j,k);
                end
            end
            Window = Window.*mask;
            BigWindow = zeros(bigwindowsize,bigwindowsize);
            for i=1:bigwindowsize
                for j=1:bigwindowsize
                    BigWindow(i,j)=IMG(Py-(bigwindowsize+1)/2+i,Px-(bigwindowsize+1)/2+j,k);
                end
            end
        end
        
        %Each particle is assigned a background intensity.
        BACKmean=[min(mean(BigWindow,1)),min(mean(BigWindow,2))];
        BACK(q,k)=min(BACKmean);
        
        %FIND Total Intensity
        INT(q,k)=(sum(Window(:))/sum(mask(:))-BACK(q,k))*(windowsize)^2;
        
        TopX=zeros(windowsize,1);
        TopY=zeros(windowsize,1);
        WSumX=0;
        WSumY=0;
        
        %Finding the center of intensity
        for j=1:size(Window,2)
            TopX(j)=sum(Window(:,j));
        end
        TopX=TopX-min(TopX);
        TopRow=sum(TopX);
        
        for j=1:size(Window,2)
            WSumX=WSumX+j*TopX(j);
        end
        
        for i=1:size(Window,1)
            TopY(i)=sum(Window(i,:));
        end
        TopY=TopY-min(TopY);
        TopColum=sum(TopY);
        
        for i=1:size(Window,1)
            WSumY=WSumY+i*TopY(i);
        end
        
        Xc(k)=WSumX/TopRow;
        Yc(k)=WSumY/TopColum;
        
        %Using center of intensity to augment middle of the spot.
        %X(q,k) (Y(q,k)) stores the coordinates of spot q in frame k
        X(q,k)=double(Px)+Xc(k)-double((windowsize+1)/2); %#ok<*AGROW>
        Y(q,k)=double(Py)+Yc(k)-double((windowsize+1)/2);
        
    end
    %waitbar(k / frames)
end
[Boy,~]=size(X);
index=1;
for i=1:Boy
    if INT(i,1)>=Thresh
        X2(index,1)=X(i,1);
        Y2(index,1)=Y(i,1);
        INT2(index,1)=INT(i,1);
        index=index+1;
    end
end
