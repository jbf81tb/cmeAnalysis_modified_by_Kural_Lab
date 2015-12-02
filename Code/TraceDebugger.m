traceX=csvread('traceX.csv');
traceY=csvread('traceY.csv');
traceINT=csvread('traceINT.csv');
%[totalmiddle,SolTwo,middleindex2trace,middleindex2frame]=LAPtwoMaker(traceX,traceY,traceINT);

FinalTraceMaker(totalmiddle,SolTwo,middleindex2trace,middleindex2frame,traceX,traceY,traceINT);