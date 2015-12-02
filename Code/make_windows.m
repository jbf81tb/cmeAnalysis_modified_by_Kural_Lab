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