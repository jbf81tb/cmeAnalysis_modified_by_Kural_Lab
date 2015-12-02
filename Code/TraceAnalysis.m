clear all
h=waitbar(0,'Analyzing Traces');
for i=1:3600
    waitbar(i/3600)
    pause(1);
end
close(h)