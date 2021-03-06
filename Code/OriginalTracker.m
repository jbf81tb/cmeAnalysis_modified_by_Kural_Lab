                                                                     
                                                                     
                                                                     
                                             
function [life,s6MaxInt,MaxInt]=OriginalTracker(filename,frames, varargin)
%Particle Tracker: Input filename, frames, and window size to get tracking.
%{
filname is the name of the tiff file (with extension) that you want to
analyze.
frames is the number of frames in the tiff file.
windowsize is the width of the analysis window.

Version 0.0 created by Comert Kural (kural.1@osu.edu)
All further versions by Josh Ferguson (ferguson.621@osu.edu)
 TO DO
    -statistical slection of frame threshold
        - I think this can only be done for a given cell type under certain
        experimental conditions. The analysis must be run with an infinite
        frame threshold to determine what the the distribution of widths
        between peaks is. It would be a little time consuming and amounts
        to just a bit of fine tuning. I think it's ok just to use tight
        requirements.
    -domain analysis
        - What defines a subdomain?
    -movement prediction
    -fix tracing for inturrupted readings
    -take all except
    -fix automatic fitting
-cursor position
-select a rectangle
%}
path='\\phypcs.physics.ohio-state.edu\kural\Scott\cmeAnalysisPackage\MovieParent\LongEx\Cell6_1s\Tracking\ProcessedTracks.mat';
newfile='LongFileColor.tif';
if nargin == 2
    windowsize = 5; filter = 'a';
elseif nargin == 3
    windowsize = varargin{1}; filter = 'a';
elseif nargin == 4
    if (ischar(varargin{2}) && (varargin{2} ~= 'a' && varargin{2} ~= 'm'))
        error('Fourth argument must be ''a'', ''m'', or a number.')
    else
        windowsize = varargin{1}; filter = varargin{2};
    end
else
    error('Too many input arguments');
end

if windowsize == 5
    mask = [0 1 1 1 0;...
            1 1 1 1 1;...
            1 1 1 1 1;...
            1 1 1 1 1;...
            0 1 1 1 0];
elseif windowsie == 7
    mask = [0 0 1 1 1 0 0;...
            0 1 1 1 1 1 0;...
            1 1 1 1 1 1 1;...
            1 1 1 1 1 1 1;...
            1 1 1 1 1 1 1;...
            0 1 1 1 1 1 0;...
            0 0 1 1 1 0 0;];
else
    mask = ones(windowsize);
end
windowsize = 2*floor((windowsize+1)/2) - 1;
bigwindowsize = windowsize + 4;
PixelSize = 160; % nm
mex = -fspecial('log',9,1.5);
%Predefine matrices. J is dynamic, IMG is static.
ss = imread(filename);
s = size(ss);
J = zeros(s(1),s(2),frames,'uint16');
IMG = zeros(s(1),s(2),frames,'double');
scale = ones([1,frames],'double');

h = waitbar(0,'Filtering images...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for j=1:frames
    IMG(:,:,j) = imread(filename,'Index',j);
    J(:,:,j) = imfilter(IMG(:,:,j),mex,'symmetric');
    if filter == 'a'
        [x,y] = create_histogram(J(:,:,j));
        scale(j) = best_fit_approx_n(x,y,5);
    end
    waitbar(j / frames);
end
close(h);

MEAN=mean(J,3);
if filter == 'm'
    SHOW = J(:,:,2);
    Scale=(min(SHOW(:)):max(SHOW(:)))';
    figure('units','normalized','outerposition',[0 0 1 1]);
    colormap(gray);
    subplot(1,7,1);
    imagesc(Scale);
    set(gca,'XTickLabel',[]);
    title('Select scaling');
    
    %This section allows you to control the level of specificity that gets put
    %into the selecting pit signals. Should eventually be automated for
    %statistical selection.
    k=0;
    while k ~= 1
        subplot(1,7,[2 3]);
        imagesc(SHOW);
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        subplot(1,7,1);
        if k==2; title('Try again'); end
        [~,Vy] = ginput(1);
        Coeff=Vy;
        imagesc(Scale);
        set(gca,'XTickLabel',[]);
        SHOWDiv=SHOW/Coeff;
        subplot(1,7,[4 5]);
        imagesc(SHOWDiv);
        BWSHOW=imregionalmax(SHOWDiv, 4);
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        subplot(1,7,[6 7]);
        imagesc(BWSHOW);
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        subplot(1,7,1);
        line([.5 1.5],[Coeff Coeff],'Color','g');
        set(gca,'XTickLabel',[]);
        k = menu('Do you want to keep this?','Yes','No') ;
    end
    close;
    
    for k = 1:frames
        scale(k) = Coeff;
    end
end

if (filter ~= 'm' && filter ~= 'a')
    for k = 1:frames
        scale(k) = filter;
    end
end

for k = 1:frames
    J(:,:,k) = J(:,:,k)/scale(k);
    J(:,:,k) = im2bw(J(:,:,k),0);
    J(:,:,k) = double(J(:,:,k)).*IMG(:,:,k);
end
    
%Predefine matrix containing binary information of pits.
BW = zeros(s(1),s(2),frames);

h = waitbar(0,'Isolating CCPs...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for k =1:frames
    BW(:,:,k) = imregionalmax(floor(J(:,:,k)), 8);
    waitbar(k / frames)
end
close(h);
%Predefine matrices for tracking CCPs. BACK and INT have arbitrary
%predefinition (will usually be too small).
B_sample = bwboundaries(BW(:,:,2),'noholes');
BACK = zeros(length(B_sample),frames);
INT = zeros(length(B_sample),frames);
Xc = zeros(frames,1);
Yc = zeros(frames,1);

h = waitbar(0,'Locating CCPs...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for k=1:frames
    B = bwboundaries(BW(:,:,k),'noholes');
    q=0;
    for m=1:length(B)
        c=cell2mat(B(m));
        q=q+1;
        Py=uint16(mean(c(:,1)));
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
        X(q,k)=double(Px)+Xc(k)-double((windowsize+1)/2); %#ok<*AGROW>
        Y(q,k)=double(Py)+Yc(k)-double((windowsize+1)/2);
        
    end
    waitbar(k / frames)
end
close(h)

[Boy,~]=size(X);
for j = 1:frames
    for i = 1:Boy
        if X(i,j) == 0, X(i,j) = Inf; end
        if Y(i,j) == 0, Y(i,j) = Inf; end
    end
end
TraceX = zeros(Boy,frames);
TraceY = zeros(Boy,frames);
TraceINT = zeros(Boy,frames);
Diffs = zeros(Boy,Boy,frames-1);

p = 0;                 %trace number
dt = (windowsize+1)/2; %distance threshold
ft = 5;                %frame threshold (needs statistical definition)

h = waitbar(0,'Creating traces...');
bar_color_patch_handle = findobj(h,'Type','Patch');
set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
for k=1:frames-1
    for m=1:Boy
        if (X(m,k)>0 && X(m,k)<s(2))
            tracex=zeros(1,frames);
            tracey=zeros(1,frames);
            traceint=zeros(1,frames);
            
            dif=Inf([1,Boy]);
            check_dif=Inf([1,Boy]);
            check=zeros([1,frames],'uint16');
            dum_x = X(m,k);
            dum_y = Y(m,k);
            
            l = k;
            check(l) = m;
            while l <= frames - 1
                %create distance vector to find distance of all particles from
                %X(m,k), with the object of finding the closest
                for n=1:Boy
                    dif(n)=sqrt((dum_x-X(n,l+1))^2+(dum_y-Y(n,l+1))^2);
                end
                Diffs(m,:,k) = dif;
                if min(dif) == 0, l = l+1; continue; end
                if size(find(dif==min(dif)),2) ~=1, l = l+1; continue; end
                check(l+1) = find(dif==min(dif));
                for n=1:Boy
                    check_dif(n)=sqrt((X(check(l+1),l+1)-X(n,l))^2+(Y(check(l+1),l+1)-Y(n,l))^2);
                end
                
                if (find(check_dif==min(check_dif)) ~= check(l) | dif(check(l+1))>dt) %#ok<OR2>
                    check(l+1) = 0;
                else
                    dum_x = X(check(l+1),l+1); dum_y = Y(check(l+1),l+1);
                end
                if (l-k)>ft
                    %sets a frame threshold, where if we recieve no
                    %signal from this area, constrained by the distance
                    %threshold, for ft frames then it could just be a
                    %new particle taking its place in the same region
                    if sum(check(l-ft:l)) == 0, break, end
                end
                l = l+1;
            end
            
            
            
            %Load temporary trace vectors with x, y, and intensity data.
            for l=k:frames
                if check(l) ~= 0;
                    tracex(l)=X(check(l),l);
                    tracey(l)=Y(check(l),l);
                    traceint(l)=INT(check(l),l);
                    %Now that these points have appeared in a trace we
                    %have to make sure they no longer appear in any
                    %further traces, so we set them to infinity.
                    X(check(l),l)=Inf;
                    Y(check(l),l)=Inf;
                end
            end
            
            %Loading a more permanent trace vector, filtering out traces which
            %are too short and that aren't made of consecutive points, also
            %creating a new numbering system.
            pos = [find(tracex) 0];
            num=numel(pos);
            if num>ft
                son=zeros(1,num);
                son(2:num)=pos(1:num-1);
                fark=pos-son;
                if numel(find(fark==1))>=ft
                    p=p+1;
                    TraceX(p,:)=tracex;
                    TraceY(p,:)=tracey;
                    TraceINT(p,:)=traceint;
                end
            end
        end
    end
    waitbar(k / (frames-1))
end
close(h);
clear TraceX TraceY TraceINT
[TraceX,TraceY,TraceINT]=TrackDecoder(path,frames);

[TraceNum,~]=size(TraceX);
T=0;
minlength=5;
summation=0;
index=1;
index2=1;
spotIndex=1;
for i=1:TraceNum
    clear inds
    inds=find(TraceX(i,:));
    if length(inds)>minlength
        for j=1:length(inds)
            intHist(index2)=TraceINT(i,inds(j));
            index2=index2+1;
        end
        T=T+1;
        summation=summation+length(find(TraceX(i,:)));
        life(index)=max(find(TraceX(i,:)))-min(find(TraceX(i,:)));
        f=find(TraceX(i,:)); 
        %clear intf intf2
        %for j=1:length(f)
        %    intf(j)=TraceINT(i,f(j));
        %    if j<=6 %needs to be changed if time between frames~=1s
        %        intf2(j)=TraceINT(i,f(j));
        %    end
        %end
        %s6MaxInt(index)=max(intf2); %cohort things
        %MaxInt(index)=max(intf);
        %index=index+1;
        
            clear firstint lastint ints
            for j=1:length(f)
                if j<=3
                    firstint(j)=TraceINT(i,f(j));
                end
                ints(j)=TraceINT(i,f(j));
                if length(f)-j<=2
                lastint(length(f)-j+1)=TraceINT(i,f(j));
                end
            end
            beginning=mean(firstint);
            middle=mean(ints);
            finish=mean(lastint);
            if beginning<middle*.75
                for j=1:5
                    fxyc(spotIndex,4)=1;
                    fxyc(spotIndex,1)=f(j);
                    fxyc(spotIndex,2)=floor(TraceX(i,f(j)))+5;
                    fxyc(spotIndex,3)=floor(TraceY(i,f(j)));
                    spotIndex=spotIndex+1;
                end
            end
            if finish<middle*.75
                for j=length(f)-4:length(f)
                    fxyc(spotIndex,4)=2;
                    fxyc(spotIndex,1)=f(j);
                    fxyc(spotIndex,2)=floor(TraceX(i,f(j)))+5;
                    fxyc(spotIndex,3)=floor(TraceY(i,f(j)));
                    spotIndex=spotIndex+1;
                end
            end
        
    end
end
ColorSpots(fxyc,filename,newfile);
%hist(intHist)
%Lifetime=summation/T;

[Boy2,~]=size(TraceX); %Boy2 is the number of traces.
if strcmp(filename(end-3:end),'tiff')
    foldername = sprintf('%s_%u',filename(1:end-5),min(uint32(scale)));
elseif strcmp(filename(end-2:end),'tif')
    foldername = sprintf('%s_%u',filename(1:end-4),min(uint32(scale)));
end
a = ls;
a = [a blanks(size(a,1))'];
a = a';
a = a(:);
name = regexp(a',strcat(foldername,'o*'),'match');
if ~isempty(name)
    foldername = strcat(name{length(name)},'o');
end
mkdir(foldername);
%The above allows you to save the same run but with different scales.

bad_ones = false(1,Boy2);
l = menu('Would you like to...','Save all traces?','Manually choose a few?');
Tx = 0; Ty = 0;
if l == 2
    h = msgbox('Creating image...');
    subplot(4,4,[1,15])
    imh = imshow(-MEAN,[]);
    axh = get(imh,'Parent');
    figh = get(axh,'Parent');
    set(figh,'WindowButtonMotionFcn',@wbmcb,...
        'Pointer','fullcross');
    IMDATA = get(imh,'CData');
    hold on;
    colors='brgycm';
    for i=1:Boy2
        j=6-mod(i,6);
        subplot(4,4,[1,15]) %make a big plot of all traces overlaying mean image
        plot(TraceX(i,TraceX(i,:)>0), TraceY(i,TraceX(i,:)>0), colors(j), 'linewidth', 2);
    end
    ptext = text('string','','VerticalAlignment','bottom');
    close(h)
end
k = 0;
while k ~= 4 %4 menu options, and the last option closes
    k=0;
    if l == 2
        k = 2;
        while(k~=0)
            k=waitforbuttonpress;
        end
    end %click on a trace to see it in more detail
    if l == 1
        h = waitbar(0,'Saving traces...');
        bar_color_patch_handle = findobj(h,'Type','Patch');
        set(bar_color_patch_handle,'EdgeColor','b','FaceColor','b');
    end
    clickx = Tx; clicky = Ty;
    for m=1:Boy2
        if (l == 1 && bad_ones(m)), continue; end
        MeanX=mean(TraceX(m,TraceX(m,:)>0));
        MeanY=mean(TraceY(m,TraceX(m,:)>0));
        if (sqrt((MeanX-clickx)^2+(MeanY-clicky)^2)<windowsize || l == 1) && ~bad_ones(m)
            T=find(TraceX(m,:));
            if l == 2
                u=0;v=0;
                j=6-mod(m,6);
                TX=TraceX(m,T);
                TY=s(1)-TraceY(m,T);
                for i=1:length(TX)-1
                    u(i) = TX(i+1)-TX(i);
                    v(i) = TY(i+1)-TY(i);
                end
                TX = TX(1:length(u));
                TY = TY(1:length(v));
                %here we plot the x-y details of the CCP
                subplot(4,4,[4,8]);
                quiver(TX,TY,u,v,0,colors(j),'LineWidth',2);
                %here we plot intensity data of what we know to be a CCP
                subplot(4,4,[12,16]);
                plot(find(TraceINT(m,:)>0),TraceINT(m,TraceINT(m,:)>0),'bo','LineWidth',3);
                hold on;
            end
            %we have, however, left out all the stuff between what we know
            %is a CCP, so to do that we use the for loop below to add in
            %any missing intensity data
            for n=1:frames
                if TraceX(m,n)==0
                    for j=1:numel(T)
                        %we want to use the window that worked for the
                        %closest reading of a CCP
                        if abs(n-T(j))==min(abs(n-T))
                            Px=uint16(TraceX(m,T(j)));
                            Py=uint16(TraceY(m,T(j)));
                            
                            if (Px-(bigwindowsize+1)/2)<1
                                Px=(bigwindowsize+1)/2;
                            end
                            if (Py-(bigwindowsize+1)/2)<1
                                Py=(bigwindowsize+1)/2;
                            end
                            if (Px+(bigwindowsize+1)/2)>s(2)
                                Px=s(2)-(bigwindowsize+1)/2;
                            end
                            if (Py+(bigwindowsize+1)/2)>s(1)
                                Py=s(1)-(bigwindowsize+1)/2;
                            end
                            
                            WindowIm = zeros(windowsize);
                            for a=1:windowsize
                                for b=1:windowsize
                                    WindowIm(a,b)=IMG(Py-(windowsize+1)/2+a,Px-(windowsize+1)/2+b,n);
                                end
                            end
                            BigWindowIm = zeros(bigwindowsize);
                            for a=1:bigwindowsize
                                for b=1:bigwindowsize
                                    BigWindowIm(a,b)=IMG(Py-(bigwindowsize+1)/2+a,Px-(bigwindowsize+1)/2+b,n);
                                end
                            end
                            
                            INTIm=sum(sum(WindowIm))-min(mean(BigWindowIm))*(windowsize)^2;
                            TraceINT(m,n)=INTIm;
                            TraceX(m,n)=NaN; %we're just looking at a window so it
                            TraceY(m,n)=NaN; %makes no sense to record position data
                            
                        end
                    end
                end
            end
            if l == 2
                %finish the plot
                subplot(4,4,[12,16]);
                plot(TraceINT(m,:),'r','LineWidth',3);
                hold off;
                subplot(4,4,[1 15]);
                plot(TraceX(m,TraceX(m,:)>0), TraceY(m,TraceX(m,:)>0), 'k', 'linewidth', 2);
                
                k = menu('Do you want to keep this?','Yes and Continue','No and Continue','Yes and Quit','No and Quit','Save All Except');
                if k == 2, bad_ones(m) = true; end
            end
            %if the CCP is good then throw that data into a file or a sheet
            if ((k == 1 || k == 3) || l == 1)
                Tr=NaN(frames,4);
                Tr(:,1)=1:frames;   % Frame Num
                Tr(:,2)=TraceX(m,:)*PixelSize;  % X
                Tr(:,3)=TraceY(m,:)*PixelSize;  % Y
                Tr(:,4)=TraceINT(m,:);  % INT
                
                indexf=find(TraceX(m,:)>0, 1, 'first' );
                indexl=find(TraceX(m,:)>0, 1, 'last' );
                
                trace_filename = [int2str(uint16(Tr(indexf,1))), '_',...
                    int2str(uint16(Tr(indexf,2)/PixelSize)), 'x',...
                    int2str(uint16(Tr(indexf,3)/PixelSize)), 'y',...
                    '_to_',...
                    int2str(uint16(Tr(indexl,2)/PixelSize)), 'x',...
                    int2str(uint16(Tr(indexl,3)/PixelSize)), 'y'];
                trace_path = sprintf('%s\\%s.csv',foldername,trace_filename);
                csvwrite(trace_path,Tr);
                if k == 3, k=4; break; end
            end
            
            if k == 4, break; end
        end
        if l == 1, waitbar(m/Boy2); end
        if k == 5, l = 1; break; end
    end
    if (l == 1 && m == Boy2), k = 4; end
end
if l == 1, close(h); end
close;
stupid_dumb_folder_system = dir(foldername);
if size(stupid_dumb_folder_system,1) == 2, rmdir(foldername); end;
    function wbmcb(src,evnt) %#ok<INUSD>
        cp = get(axh,'CurrentPoint');
        xpos = round(cp(1,1));
        ypos = round(cp(1,2));
        if(xpos>=1 && xpos<=size(IMDATA,2) && ypos>=1 && ypos<=size(IMDATA,1))
            Tx = xpos;
            Ty = ypos;
            set(ptext,'string',sprintf('(%u,%u)',Tx,s(1)-Ty),'Position',[cp(1,1),cp(1,2)]);
        end
    end
end



function [ x, y ] = create_histogram (J)
%Creating a log-scaled histogram of image intensities.
[why,ex] = hist(double(J(:)),single(max(max(J))));
y = why(2:length(why));
x = ex(2:length(ex));
y = log(y+1);
end

function [ scale ] = best_fit_approx_n( x, y, n )
%Smooth a function using straight line approximations.
%   Currently store a bunch of detailed variables, but
%   I only need it for the x intercept.
w = 2*n+1;
xx = x(1);
for i = 1:(length(x)-1)
    if i <= n
        d = (x(i+1)-x(i))/(n+1-i);
    elseif i >= (length(x)-n)
        d = (x(i+1)-x(i))/(n-(length(x)-1-i));
    else
        d = 1;
    end
    
    xx = [xx (x(i)+d):d:x(i+1)];
end
yy = spline(x,y,xx);

new_y = zeros([1,length(y)]);
m = zeros([1,length(y)]);
x_int = zeros([1,length(y)]);
r = zeros([1,length(y)]);

new_y(1) = y(1);
new_y(length(y)) = y(length(y));


k = 1+n; i = 2;
while k<length(xx)
    xsum = 0; ysum = 0; xsum2 = 0; ysum2 = 0; xysum = 0;
    for j = (k-n):(k+n)
        xsum = xsum + xx(j);
        ysum = ysum + yy(j);
        xsum2 = xsum2 + xx(j)^2;
        ysum2 = ysum2 + yy(j)^2;
        xysum = xysum + xx(j)*yy(j);
    end
    
    if ysum2 == 0
        m(i)=0;new_y(i)=0;x_int(i)=0;r(i)=0;
    else
        sx = sqrt((xsum2-xsum^2/w)/(w-1));
        sy = sqrt((ysum2-ysum^2/w)/(w-1));
        if sx==0 || sy ==0
            m(i)=0;new_y(i)=0;x_int(i)=0;r(i)=0;
        else
            m(i) = (w*xysum - xsum*ysum)/(w*xsum2-xsum^2);
            b = (ysum - m(i)*xsum)/w;
            new_y(i) = m(i)*xx(k)+b;
            x_int(i) = -b/m(i);
            r(i) = ((xysum-xsum*ysum/w)/((w-1)*sx*sy))^2;
        end
    end
    
    if i < n
        k = k+1+n-i;
    elseif i > (length(x)-n)
        k = k+1+n-(length(x)-i);
    else
        k = k+1;
    end
    i=i+1;
end

dum = r>0.9;
for i = 1:length(dum)
    if (dum(i) == true && (x_int(i) > median(x_int(dum))+std(x_int(dum)) || x_int(i) < median(x_int(dum))-std(x_int(dum))))
        dum(i) = false;
    end
end
scale = floor(mean(x_int(dum)));
end

function [Window, BigWindow] = make_windows(Px,Py,windowsize,s,IMG)
bigwindowsize = windowsize + 4;
Window = 0; BigWindow = 0;

if (Px-(bigwindowsize+1)/2)<1 && (Py-(bigwindowsize+1)/2)<1
    for i=1:(windowsize-1)/2-Py
        for j=1:(windowsize-1)/2-Px
            Window(i,j)=IMG(i,j);
        end
    end
    
    for i=1:(bigwindowsize-1)/2-Py
        for j=1:(bigwindowsize-1)/2-Px
            BigWindow(i,j)=IMG(i,j);
        end
    end
    
elseif (Px-(bigwindowsize+1)/2)<1 && (Py+(bigwindowsize+1)/2)>s(1)
    for i=(Py-(windowsize-1)/2):s(1)
        for j=1:(windowsize-1)/2-Px
            Window(i+1-(Py-(windowsize-1)/2),j)=IMG(i,j);
        end
    end
    
    for i=(Py-(bigwindowsize-1)/2):s(1)
        for j=1:(bigwindowsize-1)/2-Px
            BigWindow(i+1-(Py-(bigwindowsize-1)/2),j)=IMG(i,j);
        end
    end
    
    
    
elseif (Px+(bigwindowsize+1)/2)>s(2) && (Py-(bigwindowsize+1)/2)<1
    for i=1:(windowsize-1)/2-Py
        for j=(Px-(windowsize-1)/2):s(2)
            Window(i,j+1-(Px-(windowsize-1)/2))=IMG(i,j);
        end
    end
    
    for i=1:(bigwindowsize-1)/2-Py
        for j=(Px-(bigwindowsize-1)/2):s(2)
            BigWindow(i,j+1-(Px-(bigwindowsize-1)/2))=IMG(i,j);
        end
    end
    
elseif (Px+(bigwindowsize+1)/2)>s(2) && (Py+(bigwindowsize+1)/2)>s(1)
    for i=(Py-(windowsize-1)/2):s(1)
        for j=(Px-(windowsize-1)/2):s(2)
            Window(i+1-(Py-(windowsize-1)/2),j+1-(Px-(windowsize-1)/2))=IMG(i,j);
        end
    end
    
    for i=(Py-(bigwindowsize-1)/2):s(1)
        for j=(Px-(bigwindowsize-1)/2):s(2)
            BigWindow(i+1-(Py-(bigwindowsize-1)/2),j+1-(Px-(bigwindowsize-1)/2))=IMG(i,j);
        end
    end
    
elseif (Px-(bigwindowsize+1)/2)<1 && (Py-(bigwindowsize+1)/2)>=1 && (Py+(bigwindowsize+1)/2)<=s(1)
    for i=1:windowsize
        for j=1:(windowsize-1)/2-Px
            Window(i,j)=IMG(Py-(windowsize+1)/2+i,j);
        end
    end
    
    for i=1:bigwindowsize
        for j=1:(bigwindowsize-1)/2-Px
            BigWindow(i,j)=IMG(Py-(bigwindowsize+1)/2+i,j);
        end
    end
    
elseif (Px+(bigwindowsize+1)/2)>s(2) && (Py-(bigwindowsize+1)/2)>=1 && (Py+(bigwindowsize+1)/2)<=s(1)
    for i=1:windowsize
        for j=(Px-(windowsize-1)/2):s(2)
            Window(i,j+1-(Px-(windowsize-1)/2))=IMG(Py-(windowsize+1)/2+i,j);
        end
    end
    
    for i=1:bigwindowsize
        for j=(Px-(bigwindowsize-1)/2):s(2)
            BigWindow(i,j+1-(Px-(bigwindowsize-1)/2))=IMG(Py-(bigwindowsize+1)/2+i,j);
        end
    end
    
elseif (Py-(bigwindowsize+1)/2)<1 && (Px-(bigwindowsize+1)/2)>=1 && (Px+(bigwindowsize+1)/2)<=s(2)
    for i=1:(windowsize-1)/2-Py
        for j=1:windowsize
            Window(i,j)=IMG(i,Px-(windowsize+1)/2+j);
        end
    end
    
    for i=1:(bigwindowsize-1)/2-Py
        for j=1:bigwindowsize
            BigWindow(i,j)=IMG(i,Px-(bigwindowsize+1)/2+j);
        end
    end
    
elseif (Py+(bigwindowsize+1)/2)>s(1) && (Px-(bigwindowsize+1)/2)>=1 && (Px+(bigwindowsize+1)/2)<=s(2)
    for i=(Py-(windowsize-1)/2):s(1)
        for j=1:windowsize
            Window(i+1-(Py-(windowsize-1)/2),j)=IMG(i,Px-(windowsize+1)/2+j);
        end
    end
    
    for i=(Py-(bigwindowsize-1)/2):s(1)
        for j=1:bigwindowsize
            BigWindow(i+1-(Py-(bigwindowsize-1)/2),j)=IMG(i,Px-(bigwindowsize+1)/2+j);
        end
    end
end
end