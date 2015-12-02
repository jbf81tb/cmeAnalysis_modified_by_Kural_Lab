load(path) %automate file detection
[~,TOTtraces]=size(tracks);
traces=0;
for i=1:TOTtraces
    if 1==1 %max(tracks(i).A)>500 %only include things that the program calls CCPs--probably not a good test for us
        traces=traces+1;
    end
end
tracksx=table({tracks.x}.','VariableNames',{'x'});
tracksy=table({tracks.y}.','VariableNames',{'y'});
tracksf=table({tracks.f}.','VariableNames',{'f'});
tracksA=table({tracks.A}.','VariableNames',{'A'});

i=1;
for k=1:TOTtraces
    if max(tracks(k).A)>Thresh
        clear x y f A isCCP
        lastf=0;
        x=tracksx.x{k,1};
        y=tracksy.y{k,1};
        f=tracksf.f{k,1};
        A=tracksA.A{k,1};
        for j=1:length(x)
            if A(j)>Thresh
                xi(j)=x(j);
                yi(j)=y(j);
                fi(j)=f(j);
                Ai(j)=A(j);
            end
        end
        for j=1:max(fi)
            num(k,j)=length(find(f==j));
        end
    end
end