load('E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell008_C1_ManualDecisions.mat')
[cs(1),ms(1)]=score(Decisions);
load('E:\CME Superfolder\CME Data\190111_Analysis\50ms\orig_movies\cell015_C1_ManualDecisions.mat')
[cs(2),ms(2)]=score(Decisions);
load('E:\CME Superfolder\CME Data\181227_Umida_30p_Cell006\cell006_Stack1_ManualDecisions_ML.mat')
[cs(3),ms(3)]=score(Decisions);
load('E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell005_C1_ManualDecisions.mat')
[cs(5),ms(5)]=score(Decisions);
load('E:\CME Superfolder\CME Data\190111_Analysis\100ms\orig_movies\cell_C1_ManualDecisions.mat')
[cs(4),ms(4)]=score(Decisions);
load('E:\CME Superfolder\CME Data\190111_Analysis\200ms\orig_movies\cell010_C1_ManualDecisions.mat')
[cs(6),ms(6)]=score(Decisions);
figure
plot(cs,'r')
hold on
plot(ms,'g')

function [cs,ms]=score(Decisions)

AC=[Decisions.D]==[Decisions.CMED];
AM=[Decisions.D]==[Decisions.MLD];
cs=mean(AC);
ms=mean(AM);
end