h=waitbar(0,'Coloring Traces');
for i=1:3600
    waitbar(i/2600)
    pause(1)
end
close(h)