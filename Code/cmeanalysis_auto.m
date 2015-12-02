function cmeAnalysis_auto
folderlist0 = dir(pwd);
wd0=pwd;
for i0=3:length(folderlist0)
    cd(folderlist0(i0).name)
folderlist=dir(pwd);
wd = pwd;
for i = 3:length(folderlist)
    dirname{i-2} = strcat(wd,'/',folderlist(i).name);
end
%%
for i = 1:size(dirname,2)
    cd(dirname{i})
    pause(.1)
    cmeAnalysis('Parameters', [1.45, 100, 16], 'condDir', pwd, 'chNames', {'ch1'}, 'markers', {'egfp'}, 'Master', 1);
    pause(.1)
    cd(wd)
    pause(.1)
end
cd(wd0)
end
end
