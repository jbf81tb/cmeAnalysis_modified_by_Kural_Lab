load('E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\cell006_Stack1_ManualDecisions.mat')
D=Decisions;
Decisions=struct([]);
for i=1:length(D(:,1))
    Decisions(i).T=D(i,1);
    Decisions(i).D=D(i,2);
end
save('E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\cell006_Stack1_ManualDecisions_st.mat','Decisions');